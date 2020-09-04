class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.0.tar.gz"
  sha256 "0ca934741aea5a86dceeb5febd61563f7d7fbd49f0c55dc0fdf6e71b8c87a590"
  license "Apache-2.0"
  head "https://github.com/oilshell/oil.git"

  bottle do
    sha256 "8e5714ec5cc0700623b37e8c6e64c2fc85bec5cb91a48ecdd23c2139d2e0615c" => :catalina
    sha256 "8e135274574ff3c21248feca2ba837e8197bba55b78c41b0f80f7a3ff0cdb3b1" => :mojave
    sha256 "89427ac26ef12831c9e1a737abad953791a753d2c806bc5cf369b152fa308b1d" => :high_sierra
  end

  def install
    # Disable hardcoded HAVE_EPOLL, unsupported in macOS
    inreplace "Python-2.7.13/pyconfig.h", /^(#define HAVE_EPOLL .*)$/, '/* \1 */'
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "./install"
  end

  test do
    assert_equal pipe_output("#{bin}/osh -c 'pwd'").strip, testpath.to_s
  end
end
