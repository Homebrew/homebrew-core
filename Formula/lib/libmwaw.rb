class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.22/libmwaw-0.3.22.tar.xz"
  sha256 "a1a39ffcea3ff2a7a7aae0c23877ddf4918b554bf82b0de5d7ce8e7f61ea8e32"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "37653004fafb534955ec3a74d532fd08fc67ddf6f0541de29d2b0122c453d99e"
    sha256 cellar: :any,                 arm64_sequoia:  "e1a2a5f288071c5a5c899ed113f87a841ec434bce245a98750a1ee1b0b2c0b64"
    sha256 cellar: :any,                 arm64_sonoma:   "952e2d7978c0a53b42c6c3bcef9faf03e878069664710baed01bbf696527f329"
    sha256 cellar: :any,                 arm64_ventura:  "14c3ef9b89eabb6d8f579cd6b4fc6b10aff80157395e25f5f4032c365e35814c"
    sha256 cellar: :any,                 arm64_monterey: "22010af06baf85faaa647b36eab334caa1f097cbe8f66d60c77bb745ce70bcd9"
    sha256 cellar: :any,                 arm64_big_sur:  "02d9d169c112c585d2c8cfaaf1406a66bb6bb5a5bd909a2e842e9e5f5b6c6aee"
    sha256 cellar: :any,                 sonoma:         "dc6f6c368344f42ba9566f294e8126a6327febfe0fdb247af4e5aff2488deb98"
    sha256 cellar: :any,                 ventura:        "b62fd5d2f18f6f8248baef2454e48bedeb6a595b4e9eeed40f90fcf6c22722a0"
    sha256 cellar: :any,                 monterey:       "79ed34d639601c2afd3bcf9c573635f5f43826623a82fc931d64ada62fd632fd"
    sha256 cellar: :any,                 big_sur:        "9830e2b0688157862cc7c2345fce55ae60955c3cca0c143fef2ab582a5d6d348"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3f1183a6f1445ed7996b31a2eca4a695e778ede67a0f7e4fa48d6687060e547d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f6f70031a248697ceaaaf2b4626511400904de27cac8f6c441196a6bf05ef1c"
  end

  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "zlib"

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
