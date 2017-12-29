class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://www.thc.org/thc-hydra/"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/8.6.tar.gz"
  sha256 "05a87eb018507b24afca970081f067e64441460319fb75ca1e64c4a1f322b80b"
  revision 1
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "b89367c6adafa6fbc00626a77da70debf335ae34cc73cae27cc123e0ceef7f01" => :high_sierra
    sha256 "6621e3262ff70cfe2c9521c912a4a904102598d89d656f995816067a30a8242e" => :sierra
    sha256 "293aecd98616776d46ed947a98a3becf5b4ffe33dbfa4731d82c3db47088d1bb" => :el_capitan
    sha256 "6bb7064cfde7148b94481738631e961cbec0d2339dbfc2f75aae076b617d7baa" => :yosemite
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
