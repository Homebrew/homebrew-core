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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a7109191d7db855c62b068e2228f1ad797b593d8004c71716c556e456c7fc45e"
    sha256 arm64_sequoia: "b2a36bd6d3f368a0118e11ccd0aec2124d23550f3f9ea8c920fb708d6784de10"
    sha256 arm64_sonoma:  "cc00de279b33f8bf62da8ba1ebdb2296386386f9657e5b6e970eb1077c8afca2"
    sha256 sonoma:        "227276128efc3606042ac5dfbbbceffc6721b8938433d5537b3f10239d42f091"
    sha256 arm64_linux:   "42dc8a91df37f4c58af048d4e637af41d4a08bbc999280875daf52a3a08e1a46"
    sha256 x86_64_linux:  "010eeef54c260dddc609509ad79bf0a30aa2ea18d4e7206c3d7e93cdeea269be"
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
    system "./configure", "--sysconfdir=#{pkgetc}",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install-all"

    (var/"run").mkpath
    (var/"spool/burp").mkpath
  end

  def caveats
    <<~CAVEATS
      Before installing the launchd entry you should configure your burp client in
        #{pkgetc}/burp.conf
    CAVEATS
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
