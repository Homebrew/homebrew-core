class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://www.thc.org/thc-hydra/"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v8.4.tar.gz"
  sha256 "b478157618e602e0a8adc412efacc1c2a5d95a8f5bfb30579fbf5997469cd8b4"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "a232db891ef64d869e251c7e10707264dd081347b40fcc042c8deccbb8938379" => :sierra
    sha256 "70d37b703909c8c29c72f5526992c674f4d872d5c9da232fecd76747d130cb50" => :el_capitan
    sha256 "913ec3343a2a1dd162f65e7152467e50712add4a71888252e3e709f516afd3f0" => :yosemite
    sha256 "f0be884560663a1bb4dcd885a0b5193098b608478c0e3de153f8149e9c074d38" => :mavericks
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
