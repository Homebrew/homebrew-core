class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://www.thc.org/thc-hydra/"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v8.5.tar.gz"
  sha256 "69b69d16ce9499f3a941836b4d8a1c8a3ff9b905c921cc8c588a3af7f65a3b4b"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "a952bfcc1783dbea0b7d10079194ad87169c6bdce65db086f23f9bcd97c02873" => :sierra
    sha256 "96ff61a7a488657ba43a7aa935f038bd7d0f39d412dde4605059d38bada51de8" => :el_capitan
    sha256 "a0247412eeaaab8c7c29b4ba41b028b0de045083d6cfd5a4179671b64ee74387" => :yosemite
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
