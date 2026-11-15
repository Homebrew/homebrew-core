class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.33.0.tar.gz"
  sha256 "3437f296ff8531b35558650b0ed7fde45cad39394329eef4064a3d4900cf101f"
  license "BSD-2-Clause"
  compatibility_version 8
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "03dd2f4462b935434362dde9c153ddb78c3866055e37dc4bdde5ea050378bd32"
    sha256 cellar: :any, arm64_tahoe:       "48eb4a1cbceb65e27ba655df61bb32064f1659328f5da3ccb9b16a382fe2ab5e"
    sha256 cellar: :any, arm64_sequoia:     "10894d7efd2668cb91f649ec1146b87a323eb79b05c355fe13e462b498ffec29"
    sha256 cellar: :any, arm64_linux:       "66896af134c8e95660a85f3ca9cab2a75e895c4b3e8b9cfe0191a14ceedff4b8"
    sha256 cellar: :any, x86_64_linux:      "ab4b0e133c907d0dfd6e809a19ce0faa88d730fc5af208b2455300c9c5a99fd2"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  resource "homebrew-test.ppm", :test do
    url "https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
    sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
  end

  # Find Threads in the installed CMake config as targets now link it publicly
  patch do
    url "https://github.com/daeho-ro/OpenJPH/commit/3dfa201688b96f3b5dab3057bce89975ba7f2ad5.patch?full_index=1"
    sha256 "7cfd6ff20a8e86fa17a60132d3c1cacc7bd2c97d6b229cf26d4482488a1374c7"
    type :unofficial
    resolves "https://github.com/aous72/OpenJPH/pull/420"
  end

  deny_network_access!

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_path_exists testpath/"homebrew.ppm"
  end
end
