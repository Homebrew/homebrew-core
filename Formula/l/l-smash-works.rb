class LSmashWorks < Formula
  desc "VapourSynth plugin"
  homepage "https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works"
  url "https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works/archive/refs/tags/1278.0.0.0.tar.gz"
  sha256 "f58e2f9e944b242ea08567455e56fe47a7a5c4244f654186446db362589dd524"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vulkan-headers" => :build
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "glslang"
  depends_on "libvpx"
  depends_on "shaderc"
  depends_on "vapoursynth"
  depends_on "vulkan-loader"
  depends_on "xxhash"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  resource "l-smash" do
    url "https://github.com/HomeOfAviSynthPlusEvolution/l-smash/archive/84740c5d960ab622f4c08b971dc59192bc27ef74.tar.gz"
    sha256 "003d20595a3e66220a906c6bb351b8de973f2141fc24613db7701191f7219d5b"
  end

  resource "obuparse" do
    url "https://github.com/HomeOfAviSynthPlusEvolution/obuparse/archive/ada116ecdfe356e8ee508bb60326bfc0d30eec4f.tar.gz"
    sha256 "72f92a28e71ef95ec48ad0fe15409701e4337ab2b565a7c6d48d5d18972685c6"
  end

  def install
    resources.each do |r|
      (buildpath/r.name).install r
    end

    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "VapourSynth/meson.build",
              "install_dir: join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth'),",
              "install_dir: '#{lib}/vapoursynth'"

    inreplace "CMakeLists.txt" do |s|
      s.gsub! 'add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/xxHash/cmake_unofficial")',
       "find_package(xxHash REQUIRED)" # Use our built xxhash instead of the bundled one
    end

    args = %w[
      -DBUILD_AVS_PLUGIN=OFF
      -Ddav1d_USE_STATIC_LIBS=OFF
      -DVPX_USE_STATIC_LIBS=OFF
      -DZLIB_USE_STATIC_LIBS=OFF
      -DENABLE_MFX=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_STATIC_LIBS=OFF
    ]

    # MFX is disabled because the Intel Media SDK is deprecated and discontinued.

    args << if Hardware::CPU.intel?
      "-DENABLE_SSE2=ON"
    else
      "-DENABLE_SSE2=OFF"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (lib/"vapoursynth").install_symlink "libLSMASHSource.so" => shared_library("libLSMASHSource") if OS.mac?
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.lsmas"
  end
end
