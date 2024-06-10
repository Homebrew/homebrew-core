class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.15.0.tar.gz"
  sha256 "b42392c66eb7292db8b56715a072908b91d72385e6fdeae56fa7653adfc5428d"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "6a2ba61357090b6335dfe167f444a87265d4e561d547ed6c217dfdf5c916d02e"
    sha256 arm64_ventura:  "79a16062df538b1505f0ac4c2f22de500e664d27f0733fea77d2c1d617b59ecd"
    sha256 arm64_monterey: "8fba5ce07170e6a08e4b84b7a74a69d21aa0478469886db7d4fcffbcb757513e"
    sha256 sonoma:         "130190812665a92ccea89f12b9398c01d63d2429d7af41b96660f3560b7ba702"
    sha256 ventura:        "8167c706e74707ecc28bcb473b747ecc8531a24d5c8027af7b5ae4c55a8b35f0"
    sha256 monterey:       "4ab6a21c67a8b5ae02489637cc3556090efaf7db743b2d49b342e04827407ae9"
    sha256 x86_64_linux:   "4f035d1e17cdaaca768ea2968e5594b58cc607f1f259c30fb60eec91397ed2a8"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pciutils" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
