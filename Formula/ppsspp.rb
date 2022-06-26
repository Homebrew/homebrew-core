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
    sha256 cellar: :any,                 arm64_monterey: "820c71423a73e7ed26f1b8d80f41e98243b3ba166e5b5873d8e8a727d5724156"
    sha256 cellar: :any,                 arm64_big_sur:  "2d86272ee827c8b963afe31ce499e542ecdf103a31e306644ceacf1bc699abc4"
    sha256 cellar: :any,                 monterey:       "599033f13849e0e6c787bc2cf42891cdf6d21e97e89eef26abef29705431cde2"
    sha256 cellar: :any,                 big_sur:        "83955e43102eb47e77bcde940baf292970d70afc4c000bdc0517ce6882870fd3"
    sha256 cellar: :any,                 catalina:       "bd285a8e382947c6cb0e2f5ff94e3e968802bb7c57f5ebc008a706b116a08f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee975b8d60106f1fbcc11d94edc856bf3e328820e3233c054655b7f1cd17079f"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
