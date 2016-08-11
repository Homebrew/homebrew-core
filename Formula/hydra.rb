class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://www.thc.org/thc-hydra/"
  url "https://www.thc.org/releases/hydra-8.3.tar.gz"
  sha256 "b94ee47254e01a8c18be38eae8b953bfe4f734db60cafd1054b3316419b1687d"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "13e14223d88e3b3357952d1f4096e1f336f00c642ac01c42840b59d1a41e1bb3" => :el_capitan
    sha256 "e2276f9b274e3a5a8f76b3e2a44d99e3accc2eb6b8c07cec7ffe7ee5b76675af" => :yosemite
    sha256 "26048c21e5dbac4796ebc0f23b4e7e77b21df35e002fe5a46bfe21c92da2498e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on :mysql
  depends_on "openssl"
  depends_on "subversion" => :optional
  depends_on "libidn" => :optional
  depends_on "libssh" => :optional
  depends_on "pcre" => :optional
  depends_on "gtk+" => :optional

  def install
    # Dirty hack to permit linking against our OpenSSL.
    # https://github.com/vanhauser-thc/thc-hydra/issues/80
    inreplace "configure" do |s|
      s.gsub! "/opt/local/lib", Formula["openssl"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl"].opt_include
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
