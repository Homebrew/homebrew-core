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
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "e2fbd7a06918037ba8d7cd4cd63aac2a91da169109846858d289abf2c506dbea"
    sha256 cellar: :any,                 big_sur:       "1fb64f1bf453622476e94460904d4f033e05f42755d3f6793775233e9a55dec9"
    sha256 cellar: :any,                 catalina:      "9b375483a60f6e4e631c5c01a0f5b69c15ff69570749d31f0af77014a6e2c373"
    sha256 cellar: :any,                 mojave:        "6d22974f4e46d094860b1b1de2ed5b1d9a77e41ae777519fe77e8172fc1ada54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c3d227fe076c5bd40e7a9d3e5f389cfcc06a5659ced66478026efdb81aa645"
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
