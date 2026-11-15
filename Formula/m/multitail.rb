class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://github.com/folkertvanheusden/multitail/archive/refs/tags/7.1.6.tar.gz"
  sha256 "bf614c53c212238bccc86bb7ab220b6b11f3997c1900a5767df4b1a79885f421"
  license "MIT"
  head "https://github.com/folkertvanheusden/multitail.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ce59d4bf00fad4ad9a71415914f0edd5b5fc0dcfd370ee8645d7d3e73c6e765d"
    sha256 cellar: :any, arm64_tahoe:       "a6200a07329926c2cb274a6a61b0c5ad0d48ebe0a3445446f686395b418f873d"
    sha256 cellar: :any, arm64_sequoia:     "bf871104383dba8093641ad568dd50d709d980410121c329e29d6300ae1c79e7"
    sha256 cellar: :any, arm64_linux:       "c4d71902a0877578e51291e4001cbebfd3d713a6b6da11c11a490ac21f1dbb91"
    sha256 cellar: :any, x86_64_linux:      "f1a937078541de162cbefb2ef827bb4917c95c1444e8d35e702aebbf0b9f0a68"
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses"

  deny_network_access!

  def install
    odie "Check if `inreplace` can be removed" if version > "7.1.6"
    inreplace "version" do |s|
      s.change_make_var! "VERSION", version.to_s
    end
    if OS.linux?
      inreplace "makefile.macosx" do |s|
        cflags = s.get_make_var("CFLAGS") + " -D_LARGEFILE64_SOURCE"
        s.change_make_var! "CFLAGS", cflags
      end
    end
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install Utils::Gzip.compress("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
  end
end
