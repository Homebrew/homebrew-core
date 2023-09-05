class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.0.5.tar.gz"
  sha256 "8046eb856fd95d9896220238c966125fb05e451e65d8cfc7eb25483767612235"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "f49d6f4e78a49383cdabf144b5f430552fdecee88d83edc24067e1611516d8c6"
    sha256 arm64_monterey: "9317d97828ffa7118a1c39ec17f27d60344d0508d1723cac70d816c09b07ed96"
    sha256 arm64_big_sur:  "3faa1f1833f128477312535afd1b1752fc9a21237ab338abaaa1ce29fdf58a59"
    sha256 ventura:        "504a64032dc690a24975b241e81221f1b4afc95069cff1919af1a9676c41cf37"
    sha256 monterey:       "55fac6d1d27fc3fccd805075a7c6fc4aba3f8306f885664e53145ef9303e2129"
    sha256 big_sur:        "bcd06af97b57d538e7206caff5cf79cfd51f8212821e8c00227becfa7778a029"
    sha256 x86_64_linux:   "e294c911eb59b5f353ff51e238c8b0a5627ad084b99ca06d048d0f72e39da1fc"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
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
