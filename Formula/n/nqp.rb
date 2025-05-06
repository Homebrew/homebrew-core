class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.04/nqp-2025.04.tar.gz"
  sha256 "6468566fd63a75b743979df433beab99690125c4d90972c3b371f6ace82528a0"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "e2463fc727bac12ca2dd08224c9b0da9e43ca68bf6b5c802da3dd1faac6ec2ed"
    sha256 arm64_sonoma:  "c3d32229c07c0bc65db3d4eaede67e497dda45b024de66e6848be3268c045581"
    sha256 arm64_ventura: "ae32fdad142b625ffb29a5d41f164f9a1f49382cc880ee2ae8e1716eb6d490a3"
    sha256 sonoma:        "636e461d6dff50ed188a840cd6b8df5debb7ae854bdbf804108cb4ea4f4fbddc"
    sha256 ventura:       "739bef0247c89a509b05876e87a2319f4d378c0ed749ee7a2ba2e742f7846eac"
    sha256 arm64_linux:   "68f61319361ee737557599af2546a18c10a4135c8e1553d3e92fd693739624f9"
    sha256 x86_64_linux:  "0dec3fcf774a1b16d4588bebeb55b646fbacdd28639e616eb591f386deb58328"
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
