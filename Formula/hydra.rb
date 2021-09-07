class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.2.tar.gz"
  sha256 "1a28f064763f9144f8ec574416a56ef51c0ab1ae2276e35a89ceed4f594ec5d2"
  license "AGPL-3.0-only"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "17478cc89073f649064ce5ed78103261eef8543df11a2601fdcfb6d19ad44154"
    sha256 cellar: :any,                 big_sur:       "e3077504146989bf221da7acd53224ecec02d95349682c98f3132e9795d79481"
    sha256 cellar: :any,                 catalina:      "310e71af53f35765106b99e890a4989f9b3856e09822f68201e288ebe0c91ff9"
    sha256 cellar: :any,                 mojave:        "61dce3743fe0b7ce2db21bd833c3a99fea8c571f2c97ce57930ffb078516af4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3033a68716117810a4882047a77587f0aa8b6b4a0f7c51c447ef5c5024fe211c"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  conflicts_with "ory-hydra", because: "both install `hydra` binaries"

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl@1.1"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl@1.1"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl@1.1"].opt_include
      # Avoid opportunistic linking of everything
      %w[
        gtk+-2.0
        libfreerdp2
        libgcrypt
        libidn
        libmemcached
        libmongoc
        libpq
        libsvn
      ].each do |lib|
        s.gsub! lib, "oh_no_you_dont"
      end
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    # remove unsupported ld flags on mac
    # related to https://github.com/vanhauser-thc/thc-hydra/issues/622
    inreplace "Makefile", "-Wl,--allow-multiple-definition", "" if OS.mac?
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hydra", 255)
  end
end
