class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.67.1.tar.gz"
  sha256 "52489550d1fdeac8bde8b3442064e3bc78d28fda752a171dc46a6cd97454f237"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "b8bec6844516995aed41736898c405d73f0b612f6de45cdb6d096f28ec9fa15d"
    sha256               arm64_sequoia: "dd837bae10d472403cfd27a2378b5bd4f2074e8c1c6db230bc55252cc3d3f678"
    sha256               arm64_sonoma:  "a894668fb01922ec49cf87bbafb8bd0c4afb9f46c292895d1999e54d7f390878"
    sha256 cellar: :any, sonoma:        "c18d476e7df154998a102fcb1b96cbec5b889c02bef941e8b5df7354da51fc30"
    sha256               arm64_linux:   "f72a70c60024f7d8a953b2a5d9c20aa96b5583ed5c46a2d435d47f054c0b2af5"
    sha256               x86_64_linux:  "44d2fc96b1e9b03083ddf01133e85b95e599c6803944c068e438975f461ba359"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "lua" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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
