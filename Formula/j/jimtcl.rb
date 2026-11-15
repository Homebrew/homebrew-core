class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "https://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/refs/tags/0.84.tar.gz"
  sha256 "435095b436b38b96dd85e8cda13878144813bf52066057f76368db178dd8fea2"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "7c2cd2211b5be4e1ffd311699cdf205f156395a77a9471ce21e8c708b4594c44"
    sha256 arm64_tahoe:       "6b3b9d1158ff0ac9bcbaa038cfbcb524105e9bd54167bba6bfc61cc9f45fc38d"
    sha256 arm64_sequoia:     "710f84b7e976b2b6651ba7e02ca96121580bdc42335bbeea985388f66432743a"
    sha256 arm64_linux:       "ba4dd4cf5da248cd9ed1b1a11f930315367a631ef74234bc95796713fccc8895"
    sha256 x86_64_linux:      "745dce246a206776f5ef8947e22809732e60036c30a6b689e4f47bf0ffae9684"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "readline"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--ssl",
                          *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end
