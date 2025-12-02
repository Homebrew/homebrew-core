class Libshout < Formula
  desc "Data and connectivity library for the Icecast server"
  homepage "https://icecast.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  sha256 "39cbd4f0efdfddc9755d88217e47f8f2d7108fa767f9d58a2ba26a16d8f7c910"
  license "LGPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libshout[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76663b1032171e339e3050387e161c4428a0831ee4c0142c76ba6fd0d4dfa767"
    sha256 cellar: :any,                 arm64_sequoia: "5ff13dd8f27961848f5a16d23ce60c171146c09424e7335eb2eaee7245a78ed3"
    sha256 cellar: :any,                 arm64_sonoma:  "86c6bd103a2d979c4d21e4b419716498cbc4662addf0db2308d91bdcebaeac48"
    sha256 cellar: :any,                 arm64_ventura: "7a69fb9e5b3562368d2ab467fe6b9bfb7b0091505a0324e943873bdec9de4eef"
    sha256 cellar: :any,                 sonoma:        "94d290dfdf67616fbf858902a09552c31ea53b9c130105735398208cb91df08f"
    sha256 cellar: :any,                 ventura:       "56982df807301d4f69684c7988c6d9c74faeb71471b453899649ab3e211b40df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac4ae07ae448d7c8ba89fb704caf46dabde6b99994aaca7f4240f99e213b9787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4015cc70b9e3b8c9d17596e744743589c3f8c0a1be06c1116054e6855a4619"
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openssl@3"
  depends_on "speex"
  depends_on "theora"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
