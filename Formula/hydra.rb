class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v8.9.1.tar.gz"
  sha256 "7c615622d9d22a65b007e545f2d85da06c422a042f720bd6c5578a1844dec40e"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "dc025662292dff699b05e525ca4e19ce9b62385eeec20fa2597e2bbfdb2c3d10" => :mojave
    sha256 "6c1d497320f91e0a366278b5186f21b5337bdd24760cb82c8225f34746ff8cf8" => :high_sierra
    sha256 "0d92b2dcac84f0dfbb12b0a26c7213a4bc1e9742ab93e061cef02958cd8fd2ef" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl"

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl"].opt_include
      # Avoid opportunistic linking of subversion
      s.gsub! "libsvn", "oh_no_you_dont"
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
