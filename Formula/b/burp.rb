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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "ebb55cbcd5d0a9de3b663e009cd4963aa456f921f2aed92be95f7865aed1d607"
    sha256 arm64_sequoia: "d6849a3d6b12bbd37eee1954a8da80f9826918e4eebd4dde260c1d2f64010a90"
    sha256 arm64_sonoma:  "d8666ed44c3c211c796589cd9b5f6dac97d1e2634193b6a1a01d84e472d3d050"
    sha256 sonoma:        "42b34598cd428004ff751be2f5db279d5cb1e36bbc1e48805a0b0d8e5d9cb6be"
    sha256 arm64_linux:   "d10d8fc59ad7ce487887298aabe8f1d68cfefdbfff43735bbdf5871311dd48ff"
    sha256 x86_64_linux:  "f5c4f3ffd0c70162456065c5abbdc737dc757bf1b043168f84bfb3b08405c66d"
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
