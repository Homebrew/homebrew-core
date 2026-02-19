class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.22/libmwaw-0.3.22.tar.xz"
  sha256 "a1a39ffcea3ff2a7a7aae0c23877ddf4918b554bf82b0de5d7ce8e7f61ea8e32"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fa0e72719088f76b8996124a739c41c4b34547cf9c4f260e58afd6ddcc870cd4"
    sha256 cellar: :any,                 arm64_sequoia: "1c5bce00ac14d8cf3e3a757459c885fdd0d590d36ffa38934632e1f574a06701"
    sha256 cellar: :any,                 arm64_sonoma:  "57398e513b5e82df0b1e72065f63e92b5260f9138c8a425e1f78c69ba54ca3cd"
    sha256 cellar: :any,                 sonoma:        "ea299bef81d475c92fcfad1e645938f555c6d84a5079736731c0bbffde56713a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "798c441a0e2c4381934c01b24f9092f808c3a40bd7535947b9bb16eea05f010c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e148bc4687e804b19b7b4d6efa771453929595be6bd06d11957c2a91be6960c"
  end

  depends_on "pkgconf" => :build
  depends_on "librevenge"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-test_document" do
      url "https://github.com/openpreserve/format-corpus/raw/825c8a5af012a93cf7aac408b0396e03a4575850/office-examples/Old%20Word%20file/NEWSSLID.DOC"
      sha256 "df0af8f2ae441f93eb6552ed2c6da0b1971a0d82995e224b7663b4e64e163d2b"
    end

    testpath.install resource("homebrew-test_document")
    # Test ID on an actual office document
    assert_equal "#{testpath}/NEWSSLID.DOC:Microsoft Word 2.0[pc]",
                 shell_output("#{bin}/mwawFile #{testpath}/NEWSSLID.DOC").chomp
    # Control case; non-document format should return an empty string
    assert_empty shell_output("#{bin}/mwawFile #{test_fixtures("test.mp3")}").chomp
  end
end
