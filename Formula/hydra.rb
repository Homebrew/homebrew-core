class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.2.tar.gz"
  sha256 "1a28f064763f9144f8ec574416a56ef51c0ab1ae2276e35a89ceed4f594ec5d2"
  license "AGPL-3.0-only"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "39d8556d476a03ffb86a748f00f8202767169f0fc0ee65cf46f16b4ee2208dc2"
    sha256 cellar: :any, big_sur:       "a7190616a3532667f98baf9d8834f38869060499d0bc6ed8edbb49451e084c84"
    sha256 cellar: :any, catalina:      "1db4a290bf2b7d04019c081f151676916e2f97f9cf2443ddfd1081cddddb193b"
    sha256 cellar: :any, mojave:        "144dbb541e91c9443026136998ea4c30d6b556674b4f429c148f1df88ce0e82c"
    sha256 cellar: :any, high_sierra:   "ca89ea37aa86dfa419ce97c414b72c9c154580cce4ccc8a4ed75fd6faa4ec826"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

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
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hydra", 255)
  end
end
