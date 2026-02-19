class Flickcurl < Formula
  desc "Library for the Flickr API"
  homepage "https://librdf.org/flickcurl/"
  url "https://download.dajobe.org/flickcurl/flickcurl-1.26.tar.gz"
  sha256 "ff42a36c7c1c7d368246f6bc9b7d792ed298348e5f0f5d432e49f6803562f5a3"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?flickcurl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ad4303f2feb50ec3bcac620cb35ec60de39f7c2f40f5d20587daa161064ce2e"
    sha256 cellar: :any,                 arm64_sequoia: "f7d7fcaa4becaba9efd332bc528a22cc9a844caac877510efa8aea89906a98bb"
    sha256 cellar: :any,                 arm64_sonoma:  "24e16a20e2a35d8c2c41e3bbb212624e5bcce261fb6cd5321b987fd4d4f83237"
    sha256 cellar: :any,                 sonoma:        "557f8c3f6763febcb01fabb8c919f5397ed33676ec13c867b9dfba0070d5e681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169ae4f2f5b364383dbf1ec5bc0dfd5f8e1fec7581fed18d4503bd9ad201f661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed038860376e8892ed82d641008301b6b4a02fbadc7404f5886b8574cdafbf91"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/flickcurl -h 2>&1", 1)
    assert_match "flickcurl: Configuration file", output
  end
end
