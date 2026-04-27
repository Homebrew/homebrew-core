class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.04/nqp-2026.04.tar.gz"
  sha256 "f3ba05cb0b99848ff19994485dc6d57c47659a3a57637a169477eae6beb9737d"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "179614861ff6bc00bc69ff9263d4e64068b5891241342643089a060f1e247561"
    sha256 arm64_sequoia: "8e1aaf7b1dc48b8f5d46f4a7381d524d1f8217d34c23194b2a40bad7e71965fb"
    sha256 arm64_sonoma:  "3c1dadd19daf701fc5dd5ae22b062afd63c69241e279805c192b945dd09eed8c"
    sha256 sonoma:        "4a9b361138c1691af5708a9092ce34da1961b70bf75f42e041e20f536ac686df"
    sha256 arm64_linux:   "90a0ff7d291625d7d9d1f166ac166d45a4c3b03045d36da55a607f8164ae2fce"
    sha256 x86_64_linux:  "557c7edf1823c4ce27e9a1ccfcacc2bddd6f2fff52bce885e4e1e48520311ff7"
  end

  depends_on "moarvm"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
