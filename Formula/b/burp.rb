class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"
  url "https://github.com/grke/burp/releases/download/3.2.0/burp-3.2.0.tar.bz2"
  sha256 "3f5e057d40d2986fbfbebdf7a64570719c4c664882a3fd038ebac5a20326c5cf"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://burp.grke.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >].*?:\s*Stable}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "c129b737a033d7fbba3e46e3b3044f89225d4cf173be9f0c22a8fb2cae29e024"
    sha256 arm64_sequoia: "53b1f61a6ac2d34c5ed8b19b91294e54e236376b806c1a2f61f5ba141888dfd8"
    sha256 arm64_sonoma:  "6646ad75dfd50d4834bbe42466f15337bc2da10e67f865216736390a79f53708"
    sha256 sonoma:        "296756b80ec859d53dcf960a4e025a2f94c184085a6739071bd19e4f3bbb7641"
    sha256 arm64_linux:   "1183e6bd117bc9a43d90ac62be599f30c3657aa4d85bfed7efe3e812e4f7bf73"
    sha256 x86_64_linux:  "7c83c81423fcb31dfd2c3e2ed7725777891a11a03f6b30c8955558b97ba09794"
  end

  head do
    url "https://github.com/grke/burp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "uthash" => :build
  depends_on "librsync"
  depends_on "openssl@4"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
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
