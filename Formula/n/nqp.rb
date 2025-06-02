class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.05/nqp-2025.05.tar.gz"
  sha256 "51f72f3c3cdd8e87fabd1601eab7c6dfef201dd4b65946848a6e38370e99458f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "5db358f1bf93f83701773f0fcc3962f96c83bf35a693775c14fff7f6f3beb595"
    sha256 arm64_sonoma:  "7f3157e5a96ce0440fcb146e6852a9da8d5778794529b9d62f23ddd7f79253d6"
    sha256 arm64_ventura: "baa7ad6e49cb3a7b79864f724eabc4eb415a43ce8a2f90741d8111d7004643d5"
    sha256 sonoma:        "2986d11bed060e67e1f62960f6f4e7ac5aea7da016993ad53424c86415287942"
    sha256 ventura:       "1cf60d0b599d6b4adb14ac21a29565f23da00c12029980c0fc2267751badeacf"
    sha256 arm64_linux:   "cd4ed34edde854b37ef78b483f18e4196e4721f5cb5c6583c35f916b75e29080"
    sha256 x86_64_linux:  "5ba65209f224f5a58771c59ec32995c163dd0f2ea4a3c0e9116519c1c4b56495"
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
