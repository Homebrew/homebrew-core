class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-3.15.tar.gz"
  sha256 "96948f6835bee8925f2556fdf187b59c77c06524e2efc72ddf2bfccb5385521c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a7df01fbc4929290c0037f10da891d4f7c0375cc441caf7f0287273bd809321" => :sierra
    sha256 "0043992f3cd8ff62bb13f6765f3c298e1f5e832bad7e63f0ec19c26c3c2cd028" => :el_capitan
    sha256 "ee07d14a055e46095b9dfdf0d6eb7502821870671572976a639f48c143cb4b72" => :yosemite
  end

  head do
    url "https://github.com/schweikert/fping.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fping -A localhost")
    assert_equal "127.0.0.1 is alive", output.chomp
  end
end
