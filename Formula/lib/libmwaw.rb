class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.23/libmwaw-0.3.23.tar.xz"
  sha256 "ac3590f691a2904eb8c7dc8b757b8a29f125f592449e421459ae8fa928b399eb"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8d25c7c58f0171849af7f60db0d87f2086ff27075a126f55c8524a765353caf"
    sha256 cellar: :any, arm64_sequoia: "876db022c48d3d9bdfc7974d80b9410bf29b5df4e6be016b84b914819f5abfeb"
    sha256 cellar: :any, arm64_sonoma:  "53960c2cdef6d3c978bf5f32e3bfba68bd7b889cf1dce3e476f2654503bd8011"
    sha256 cellar: :any, sonoma:        "7387a6e3c8b1a816bbf6be7de71bb2acaca6c5286f67b9a20967338bc80a1ce5"
    sha256 cellar: :any, arm64_linux:   "0ab494479d8cff29f5334448530a761c69f4a1a9294a001ec7553210fd5c38f6"
    sha256 cellar: :any, x86_64_linux:  "ad976802e1baea7704a6e8968821f4471a69a934b395f7e6977be5e067b6e2e9"
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
