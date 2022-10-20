class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

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
    sha256 arm64_monterey: "5b49f738c6755ed1661d0f4d17b2cfd5543316f775d6a17eac32bed217c6b84a"
    sha256 arm64_big_sur:  "b61e5e1920d691c06ef16e4fd2ec8a9ccca26c305bd9e8403c6d25a95327403b"
    sha256 monterey:       "6917c1084a60abd9e9f3c4b598550364d0e48ec834794ae874628535fa9b49f1"
    sha256 big_sur:        "d542ee4aede6d4fb0d651b9888cac192fde50285889fd716b224d62ccd3b0cf2"
    sha256 catalina:       "7dda2191539b4da970fcab02ff231b13a897bb809972f7a505fa74f676ec026d"
    sha256 x86_64_linux:   "f0e3b60c6274bca19bfa073972a4f5eafc4d961f2024d975be6ddc9808d9c552"
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

  depends_on "pkg-config" => :build
  depends_on "librsync"
  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    resource("uthash").stage do
      (buildpath/"uthash/include").install "src/uthash.h"
    end

    ENV.prepend "CPPFLAGS", "-I#{buildpath}/uthash/include"

    system "autoreconf", "-fiv" if build.head?

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

  plist_options startup: true

  service do
    run [opt_bin/"burp", "-a", "t"]
    run_type :interval
    keep_alive false
    interval 1200
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"burp", "-V"
  end
end
