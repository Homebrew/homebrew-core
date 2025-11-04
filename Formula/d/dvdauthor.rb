class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "https://dvdauthor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor-0.7.2.tar.gz"
  sha256 "3020a92de9f78eb36f48b6f22d5a001c47107826634a785a62dfcd080f612eb7"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?/dvdauthor[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed44deb629315e130b499c9e41a1cdfd789d62ed26e410c10d480a27ea93abec"
    sha256 cellar: :any,                 arm64_sequoia: "17b2f6a33354311992ca16d0f2455671df0f23b65cdb83088ff383b0fd78daff"
    sha256 cellar: :any,                 arm64_sonoma:  "4c5905690b4f281fb0351cb5581bc42775c09a10d1ce9567fba4e0b5159edde3"
    sha256 cellar: :any,                 sonoma:        "dcecfc37b18314b6ac3fcd27b1a11785eeedf6d20e0d78d81e0888181250a4b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb55a46434f9c854c8aae0422b4f964c2fedc9ccc3fa01183e93dda87f196f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb347b5f1afad654bd82dbf2158c3e1565b2ebfcf45b0e12828de5c5d3e46439"
  end

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "libdvdread"
  depends_on "libpng"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make"
    ENV.deparallelize # Install isn't parallel-safe
    system "make", "install"
  end

  test do
    assert_match "VOBFILE", shell_output("#{bin}/dvdauthor --help 2>&1", 1)
  end
end
