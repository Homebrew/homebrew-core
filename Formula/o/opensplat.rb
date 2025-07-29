class Opensplat < Formula
  desc "Open source 3D Gaussian Splatting implementation"
  homepage "https://github.com/pierotofy/opensplat"
  url "https://github.com/pierotofy/opensplat/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "fc6236cd4a72e945cc6ae2ced83879068a6e3fc68b2bc0e45113022b92542c3c"
  license "AGPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "cxxopts" => :build
  depends_on "glm" => :build
  depends_on "nanoflann" => :build
  depends_on "nlohmann-json" => :build
  depends_on "colmap" => :test
  depends_on "opencv"
  depends_on "pytorch"

  on_macos do
    depends_on xcode: ["15.0", :build] # for metal
  end

  def install
    # Upstream fetches dependencies from GitHub at build time
    inreplace "CMakeLists.txt" do |s|
      s.gsub!(/FetchContent_Declare\(nlohmann_json\s*URL[^)]+\)/, "find_package(nlohmann_json REQUIRED)")
      s.gsub!(/FetchContent_Declare\(nanoflann\s*URL[^)]+\)/, "find_package(nanoflann REQUIRED)")
      s.gsub!(/FetchContent_Declare\(cxxopts\s*URL[^)]+\)/, "find_package(cxxopts REQUIRED)")
      s.gsub!(/FetchContent_Declare\(glm\s*URL[^)]+\)/, "find_package(glm REQUIRED)")
      s.gsub!("FetchContent_MakeAvailable(nlohmann_json nanoflann cxxopts)", "")
      s.gsub!("FetchContent_MakeAvailable(glm)", "")
    end

    gpu_runtime = if OS.mac?
      "MPS"
      # TODO: on Seqoia this seems to not be building with Metal, but I have Xcode 26 beta.
      # Will test later on my standard Xcode machine
    elsif OS.linux?
      if which("nvcc")
        "CUDA"
      elsif which("hipcc")
        "HIP"
      else
        "CPU"
      end
    else
      "CPU"
    end

    args = %W[
      -DCMAKE_PREFIX_PATH=#{Formula["pytorch"].opt_libexec}/torch
      -DGPU_RUNTIME=#{gpu_runtime}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install Metal library for MPS GPU support on macOS
    if OS.mac?
      metallib_file = buildpath/"build/default.metallib"
      metal_source = buildpath/"rasterizer/gsplat-metal/gsplat_metal.metal"

      if metallib_file.exist?
        # Install precompiled Metal library next to binary
        cp metallib_file, bin/"default.metallib"
        ohai "Installed Metal library for GPU support"
      elsif metal_source.exist?
        # Install Metal source as fallback next to binary
        cp metal_source, bin/"gsplat_metal.metal"
        ohai "Installed Metal source for runtime compilation"
      else
        opoo "Neither Metal library nor source found - GPU support disabled"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensplat --version")

    # Minimal COLMAP project structure
    mkdir_p testpath/"sparse/0"
    mkdir_p testpath/"images"

    # Minimal cameras.txt
    cameras_txt = testpath/"sparse/0/cameras.txt"
    cameras_txt.write <<~EOS
      1 PINHOLE 1 1 0.5 0.5 0.5 0.5
    EOS

    # Minimal images.txt
    images_txt = testpath/"sparse/0/images.txt"
    images_txt.write <<~EOS
      1 1.0 0.0 0.0 0.0 0.0 0.0 0.0 1 test.jpg
      0.5 0.5 1
      2 0.9 0.1 0.0 0.0 0.1 0.0 0.0 1 test2.jpg
      0.5 0.5 2
    EOS

    # Minimal points3D.txt
    points3d_txt = testpath/"sparse/0/points3D.txt"
    points3d_txt.write <<~EOS
      1 0.0 0.0 1.0 128 128 128 0.5 1 0 2 0
      2 1.0 0.0 1.0 128 128 128 0.5 1 1 2 1
    EOS

    # Copy test images
    cp test_fixtures("test.jpg"), testpath/"images/test.jpg"
    cp test_fixtures("test.jpg"), testpath/"images/test2.jpg"

    # Convert text format to binary format using COLMAP
    system "colmap", "model_converter", "--input_path", testpath/"sparse/0",
           "--output_path", testpath/"sparse/0", "--output_type", "BIN"

    # Test GPU detection and fallback behavior
    gpu_output = shell_output(
      "#{bin}/opensplat #{testpath} --num-iters 1 --downscale-factor 1 --num-downscales 0 2>&1",
    )
    assert_match(/Using MPS/, gpu_output, "Should detect MPS GPU backend")
    assert_match(/GPU support not built/, gpu_output, "Should gracefully handle missing GPU support")

    # Test successful CPU processing
    cpu_output = shell_output(
      "#{bin}/opensplat #{testpath} --num-iters 10 --cpu --downscale-factor 1 --num-downscales 0 2>&1",
    )
    assert_match(/step \d+:/i, cpu_output, "Should successfully process with CPU")
    assert_match(/Using CPU/i, cpu_output, "Should confirm CPU usage")
  end
end
