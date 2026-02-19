class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  stable do
    url "https://github.com/grke/burp/releases/download/3.2.0/burp-3.2.0.tar.bz2"
    sha256 "3f5e057d40d2986fbfbebdf7a64570719c4c664882a3fd038ebac5a20326c5cf"

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
    rebuild 1
    sha256 arm64_tahoe:   "8299d856b7c33e46727a2baeca69c5a99cf072afa966c420d555d2b778ba382b"
    sha256 arm64_sequoia: "410ffad86ce38295589c03a0fbe7d7825c3be2064056a82834d3607cc6660f1c"
    sha256 arm64_sonoma:  "605e51882accc26159aacc07dfd50cfb5838fbd991113c412435b569eaae41b4"
    sha256 sonoma:        "286a00e3a1be4055262eefdbe1250e7d4ca888dde0534c767c0e2b3eb45e47b0"
    sha256 arm64_linux:   "08d555e3cd1915263f34d05eda67342ed8d83dddfeba72b462ba3f9b967aaada"
    sha256 x86_64_linux:  "3eed28a4c204464ea71a807e81554b05a12a3aacd71c12ded2e6925ff0c7a0eb"
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

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
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
