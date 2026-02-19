class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp/releases/download/v1.19.3/ppsspp-1.19.3.tar.xz"
  sha256 "054401fa7fffbd99b7fd80e98a2951d6f0c3de83cb4b54719899c98bfad99614"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  revision 1
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7d8507401f4e745237b48858f7ffcccccb3ef2f7efe4ae833b281dc8a3463cc4"
    sha256 cellar: :any, arm64_sequoia: "495a5a9ed7fd17fbc17352493d5b41b59c807d4be7da0ba1e96f509de2a536fa"
    sha256 cellar: :any, arm64_sonoma:  "a4a192083bfe3c14daf8c2f1e441c5622682dc82299760124d979e59943e505b"
    sha256 cellar: :any, sonoma:        "f6b884e3026c9ff3baaf94442a1725a3825bb45cbf3a0cdc6be516235774bf18"
    sha256               arm64_linux:   "c724f38ada1c053f366e892d2a6f41c725f2b2f5ce66ed50d1b177a804e1c59e"
    sha256               x86_64_linux:  "ac927fdce2dde31ccf61ca1a3afc3c657e648d63e6e37a07d4f362d64c2a4456"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "yasm" => :build

  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "glew"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    # ARM uses a bundled, unreleased libpng.
    # Make unconditional when we have libpng 1.7.
    depends_on "libpng"
  end

  def install
    # Build PPSSPP-bundled ffmpeg from source. Changes in more recent
    # versions in ffmpeg make it unsuitable for use with PPSSPP, so
    # upstream ships a modified version of ffmpeg 3.
    # See https://github.com/Homebrew/homebrew-core/issues/84737.
    cd "ffmpeg" do
      if OS.mac?
        rm_r("macosx")
        system "./mac-build.sh"
      else
        rm_r("linux")
        arch = Hardware::CPU.intel? ? "x86-64" : Hardware::CPU.arch
        system "./linux_#{arch}.sh"
      end
    end

    # Workaround for error: use of undeclared identifier `fseeko|ftello|ftruncate`
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    vulkan_frameworks = buildpath/"ext/vulkan/macOS/Frameworks"
    vulkan_frameworks.install_symlink Formula["molten-vk"].opt_lib/"libMoltenVK.dylib"

    args = %w[
      -DUSE_SYSTEM_LIBZIP=ON
      -DUSE_SYSTEM_SNAPPY=ON
      -DUSE_SYSTEM_LIBSDL2=ON
      -DUSE_SYSTEM_LIBPNG=ON
      -DUSE_SYSTEM_ZSTD=ON
      -DUSE_SYSTEM_MINIUPNPC=ON
      -DUSE_WAYLAND_WSI=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      prefix.install "build/PPSSPPSDL.app"
      bin.write_exec_script prefix/"PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"

      # Replace app bundles with symlinks to allow dependencies to be updated
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      ln_sf (Formula["molten-vk"].opt_lib/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
    else
      system "cmake", "--install", "build"
    end

    bin.install_symlink "PPSSPPSDL" => "ppsspp"
  end

  test do
    system bin/"ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_path_exists app_frameworks/"libMoltenVK.dylib", "Broken linkage with `molten-vk`"
    end
  end
end
