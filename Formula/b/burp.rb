class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  stable do
    url "https://github.com/grke/burp/releases/download/2.4.0/burp-2.4.0.tar.bz2"
    sha256 "1f88d325f59c6191908d13ac764db5ee56b478fbea30244ae839383b9f9d2832"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash/archive/refs/tags/v2.3.0.tar.gz"
      sha256 "e10382ab75518bad8319eb922ad04f907cb20cccb451a3aa980c9d005e661acc"
    end
  end

  livecheck do
    url "https://burp.grke.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >].*?:\s*Stable}i)
  end

  bottle do
    sha256 arm64_sequoia:  "2e9356b11a8e46c3be3414b7a2f88dc01974d49a9b18372f5e92e5654d59144b"
    sha256 arm64_sonoma:   "839b8941718ab30883533b6cdaf415cb0b6aa085a2dfc53a5439c3cdd6c8e563"
    sha256 arm64_ventura:  "e1360b199ce42bba04f10443f26954d9c3dafe03b7565b571382f6baaad21bd2"
    sha256 arm64_monterey: "c69b19653c7d88ecb561c6116e50208b79834dc5e547396630b2c9fe6a873153"
    sha256 arm64_big_sur:  "91a2441ee60e0cbacc3e6707be43725a65fc161e24e66cbf67dbd1255aea1ff1"
    sha256 sonoma:         "074e7ecd4259269a27e59b057a9dc502438caf0d52d4e951db492ba2d05ca668"
    sha256 ventura:        "9a7d37e6cbe57a298cd83d7ab19960895329906bcf828113a98e159ac5baf8d0"
    sha256 monterey:       "a1aeb87a73af8ecf56631e3a3ac97732cc391afbe4d3651e05b390f0777f91de"
    sha256 big_sur:        "bde32d67b881d607349d196ecd79aac7cc92256e3ce94731bf27f90eb99ace53"
    sha256 arm64_linux:    "2cf103f7f0a674d270df1ae3ffcb7b8aec575b6c4b4a86f06a16f77b2f4b1ca9"
    sha256 x86_64_linux:   "3e0b7b18c51c5e0bd4160c6c9feba24bae0a4a3b1dad8c91e5c9f5f77736a113"
  end

  head do
    url "https://github.com/grke/burp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git", branch: "master"
    end
  end

  depends_on "pkgconf" => :build
  depends_on "librsync"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "acl"
  end

  def install
    resource("uthash").stage do
      (buildpath/"uthash/include").install "src/uthash.h"
    end

    ENV.prepend "CPPFLAGS", "-I#{buildpath}/uthash/include"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}"

    system "make", "install-all"
  end

  def post_install
    (var/"run").mkpath
    (var/"spool/burp").mkpath
  end

  def caveats
    <<~EOS
      Before installing the launchd entry you should configure your burp client in
        #{etc}/burp/burp.conf
    EOS
  end

  service do
    run [opt_bin/"burp", "-a", "t"]
    run_type :interval
    keep_alive false
    require_root true
    interval 1200
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"burp", "-V"
  end
end
