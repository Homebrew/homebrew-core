class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.11.3",
      revision: "f7ace3b8ee33e97e156f3b07f416301e885472c5"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  revision 1
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c8effda7a7500a6144675a367395b70c0d7da252eccc5449e5e0e60153ccbc50"
    sha256 cellar: :any,                 arm64_big_sur:  "efb8896e778451364b3d7f3c91507a0f9d390aa8b5255a31c3ca1f6eeac70d46"
    sha256 cellar: :any,                 monterey:       "7ce9efcf47d1a9ebeacc36d6c8a13bc0379bb99d26135ebebbb69cee2fe7e4f1"
    sha256 cellar: :any,                 big_sur:        "15a4c66eb2b8fc4af70e8992714660a95b0546b58979c4eb6c076c7ce398efbc"
    sha256 cellar: :any,                 catalina:       "701e9c89b53df03f4c80c2a0c9a7a957126ec0ab0d5b523e766cd4bc96fec027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d32caa759246b16d155dcb2a8474202a28f640357d7f811d9d6db33b15b1e81"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "libpng"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "snappy"

  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "glew"
  end

  def install
    # Build PPSSPP-bundled ffmpeg from source. Changes in more recent
    # versions in ffmpeg make it unsuitable for use with PPSSPP, so
    # upstream ships a modified version of ffmpeg 3.
    # See https://github.com/Homebrew/homebrew-core/issues/84737.
    cd "ffmpeg" do
      if OS.mac?
        rm_rf "macosx"
        system "./mac-build.sh"
      else
        rm_rf "linux"
        system "./linux_x86-64.sh"
      end
    end

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    rm "MoltenVK/macOS/Frameworks/libMoltenVK.dylib"
    (buildpath/"MoltenVK/macOS/Frameworks").install_symlink Formula["molten-vk"].opt_lib/"libMoltenVK.dylib"

    mkdir "build" do
      args = std_cmake_args + %w[
        -DUSE_SYSTEM_LIBZIP=ON
        -DUSE_SYSTEM_SNAPPY=ON
      ]

      system "cmake", "..", *args
      system "make"

      if OS.mac?
        prefix.install "PPSSPPSDL.app"
        bin.write_exec_script "#{prefix}/PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"
        mv "#{bin}/PPSSPPSDL", "#{bin}/ppsspp"

        # Replace app bundles with symlinks to allow dependencies to be updated
        app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
        ln_sf (Formula["molten-vk"].opt_lib/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
        ln_sf (Formula["sdl2"].opt_lib/"libSDL2-2.0.0.dylib").relative_path_from(app_frameworks), app_frameworks
      else
        bin.install "PPSSPPSDL" => "ppsspp"
      end
    end
  end

  test do
    system "#{bin}/ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_predicate app_frameworks/"libMoltenVK.dylib", :exist?, "Broken linkage with `molten-vk`"
      assert_predicate app_frameworks/"libSDL2-2.0.0.dylib", :exist?, "Broken linkage with `sdl2`"
    end
  end
end
