class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.65.1.tar.gz"
  sha256 "c4a9d191601bae302cfa9939f2b5666d2565e83229840cd00554c4913646f0ad"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "60ac274b0e2d77f28f085f0c4ce4deae40671fb1d5b17a7d309bd7a4450ecfdd"
    sha256               arm64_sequoia: "d3b074cadf0828c86e292a82410a3c89e74bc20cf7f9e1cac358fe45024faf2d"
    sha256               arm64_sonoma:  "0bf4bb710d6863a24ebcacaab8836e498ee2dc713347f867ec6d0c57c01bcd2d"
    sha256 cellar: :any, sonoma:        "94b3ee6d02cbff863b0668a5e70047776b9292574d67674f18960e3aadd59c31"
    sha256               arm64_linux:   "70cc6700827c353939a3be6d22d96272d33a5e1e8e2113daf350321b8fd4d682"
    sha256               x86_64_linux:  "ab88ac8111ebb07e0afd32a75ccc58de93bc3048047edf0c40f5fcf5eec9724d"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "lua"
  depends_on "yyjson"

  uses_from_macos "sqlite" => :build

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
