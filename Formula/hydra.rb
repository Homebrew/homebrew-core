class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v8.9.1.tar.gz"
  sha256 "7c615622d9d22a65b007e545f2d85da06c422a042f720bd6c5578a1844dec40e"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "c165bb2e4f0bfef32b3724a4099338b555db27c90d0122dce05a84b70c7842ff" => :mojave
    sha256 "fbfb0ff9667b01580fb9a8a5443ff743681e0af58ad166467ffdebee68962491" => :high_sierra
    sha256 "2529988ef9e2ba82b6fd3faadb9966cfc71b4b51aa4b328c688984dc24adb952" => :sierra
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
