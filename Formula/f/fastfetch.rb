class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.62.0.tar.gz"
  sha256 "b3b18ba33e0d1af732716a28dc6c17bcb29ef1286d929f8a0aec3f7c57ffb010"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "cf3b846dc7535845048f9ac59fa4be5dc7a19a96ada2bdcfd26b9d6b0eaf0e1d"
    sha256               arm64_sequoia: "998e7a32c1e1e381cdeb93a480625605e2eec6f58809ddfa9793bd33db9b8f51"
    sha256               arm64_sonoma:  "ccfbd3f0f1c28d2a1d9d630dd3c5b9f9301179f17347f3e69c61ac23cc46d319"
    sha256 cellar: :any, sonoma:        "7852968c15fa3371ee0c25a2200cf7047f40b24f3019995b58e62787a0737f7d"
    sha256               arm64_linux:   "30685dcfd27145ab2bfea039ad35012de64b8c0e897bb210d10eab34ec0ebfb1"
    sha256               x86_64_linux:  "d720b24588515607ca6981d1f38abae5f56f68d0d4b29c9aa2203fc77be50767"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
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
