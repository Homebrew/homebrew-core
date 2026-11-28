class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.72.0.tar.gz"
  sha256 "7d5964e7e91a2bc04725cf8fb7f4b0481d528e797dbf2ef60a095cc1b82123e7"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "454df5cfd12a50307607b0857dfa3903eb811259952dc288abcc8cc033494139"
    sha256 arm64_golden_gate: "8253686488f6665c902c2968e21248cee775fe23c963e1512986d65129f89765"
    sha256 arm64_tahoe:       "99c90b028b49f9b388c0097fc810331a04434637a02343d245dcc050df265cc5"
    sha256 arm64_sequoia:     "8a247b08f1f1579e5a1c9b586fdda4476c01849ff79a4aaa0d24824b1dcef347"
    sha256 arm64_linux:       "f2e20e91d93c7a48d6daf8450fe32b9a1aa19bec0f20b5214ff0bfcde400a7bb"
    sha256 x86_64_linux:      "5937357587c5de3706da8c260c2963bcddf4df9111fdc1e6e36de4a7e0e033b7"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "lua" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

  uses_from_macos "sqlite" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1700
  end

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
    depends_on "zlib-ng-compat" => :build
  end

  fails_with :clang do
    build 1700
    cause "Requires C23 auto type inference"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
    if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
      # CMake already adds default Homebrew prefixes to rpath.
      args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
