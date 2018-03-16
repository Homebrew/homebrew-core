class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://www.thc.org/thc-hydra/"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/8.6.tar.gz"
  sha256 "05a87eb018507b24afca970081f067e64441460319fb75ca1e64c4a1f322b80b"
  revision 1
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "5f7dac7a0761023b70750c19db74027fd2eaded578d49192c20554a0f7bdedad" => :high_sierra
    sha256 "474ee0cfcf4e20992f66c6104067311ad48885d708134bb7930c5edc9214a53e" => :sierra
    sha256 "cfa0416738af22ba2b45833de89e19697f10e2c2392f7d866fa9d6e17a7a882f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "mysql"
  depends_on "openssl"
  depends_on "subversion" => :optional
  depends_on "libidn" => :optional
  depends_on "libssh" => :optional
  depends_on "pcre" => :optional
  depends_on "gtk+" => :optional

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl"].opt_include
      # Avoid opportunistic linking of subversion
      s.gsub! "libsvn", "oh_no_you_dont" if build.without? "subversion"
      # Avoid opportunistic linking of libssh
      s.gsub! "libssh", "certainly_not" if build.without? "libssh"
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hydra", 255)
  end
end
