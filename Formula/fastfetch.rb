class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.8.2.tar.gz"
  sha256 "552f4239a83d31e2fb14bdf7fc5d74cc6cc819f8b6ddd2346ba0dcfac13ac62a"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "ac9d09a9731c757dae6368f3cca879f16c4acf52b22db02d3733e310ee3666ff"
    sha256 arm64_monterey: "0121763010038f4094c09b2b9e7e038d4aa4ea302e17befc271c4169bdc147bc"
    sha256 arm64_big_sur:  "e077d8226fdff1bfed090c4de7fa613d39fa70cb2f1ebb73cd85ea12fb3cc30c"
    sha256 ventura:        "596c4aa510503591dbabd46a7d243192f437f9d1a28933d4245a1f817f5bf326"
    sha256 monterey:       "5465e613038aa64ecb56a824e6f062be8f68361eed26255d4ba07e0c85af15f5"
    sha256 big_sur:        "064f761cdbe8e932017e928dd8988dd41694a3f2f293d49e73ca9919a63328bb"
    sha256 x86_64_linux:   "1dbdbfb8cd1a57efd0f7ca2f10b039664d7d51cc37e300ceb7b044e39725e59d"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
