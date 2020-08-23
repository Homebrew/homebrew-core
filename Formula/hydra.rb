class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.1.tar.gz"
  sha256 "ce08a5148c0ae5ff4b0a4af2f7f15c5946bc939a57eae1bbb6dda19f34410273"
  license "AGPL-3.0"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "1db4a290bf2b7d04019c081f151676916e2f97f9cf2443ddfd1081cddddb193b" => :catalina
    sha256 "144dbb541e91c9443026136998ea4c30d6b556674b4f429c148f1df88ce0e82c" => :mojave
    sha256 "ca89ea37aa86dfa419ce97c414b72c9c154580cce4ccc8a4ed75fd6faa4ec826" => :high_sierra
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
