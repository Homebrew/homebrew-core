class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.53.0.tar.gz"
  sha256 "1488d9b738474e8ef8e8d78e2463722bf706e435857c849b3f480354ad62366e"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "0aba51d7b33a46593a91c0e2078a54aecb5f3c15edc268126abcfdd9f5de2aa4"
    sha256               arm64_sequoia: "5df3c119180702f4df106c212ad75f49535790b52db6b8b0ff16f88cf397ea4c"
    sha256               arm64_sonoma:  "d4822ceb5505164b2b7c8a3e97945064e733c95f871222d1902be4ec578329df"
    sha256 cellar: :any, sonoma:        "d44771ec9103085fbb02994dd2e9d02370681655453be957523d72bf9d43c5f4"
    sha256               arm64_linux:   "3bfbcfee517e66868739eb37d0b306464b77c1209eea0a66a6577065697ac76f"
    sha256               x86_64_linux:  "abcefd143a1dc69a9886b246fe8e012266b9485871f806c899f14fddbea1fc82"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

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
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
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
