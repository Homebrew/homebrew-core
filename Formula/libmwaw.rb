class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.13/libmwaw-0.3.13.tar.xz"
  sha256 "db55c728448f9c795cd71a0bb6043f6d4744e3e001b955a018a2c634981d5aea"

  bottle do
    cellar :any
    sha256 "df8f0b79f09b6fa30a010d892d603ad132b7e3afcd99b4ddb3de18b4b58e9991" => :high_sierra
    sha256 "e819d6a8f20f6cbab7d4cbdb189e2ee3ce1c974e596134e3b80927b6c70ea54a" => :sierra
    sha256 "bdcd4556d74bfa584addfb584b2ebdab04746662955d4d265c762944243d9398" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  resource "test_document" do
    url "https://github.com/openpreserve/format-corpus/raw/825c8a5af012a93cf7aac408b0396e03a4575850/office-examples/Old%20Word%20file/NEWSSLID.DOC"
    sha256 "df0af8f2ae441f93eb6552ed2c6da0b1971a0d82995e224b7663b4e64e163d2b"
  end

  # Remove for > 0.3.13
  # Upstream commit from 15 Nov 2017 "fix call of explicit ctor"
  # See https://sourceforge.net/p/libmwaw/libmwaw/ci/4bc8ec0481f89b989b0c34236c9d5d9b8038d4a9/
  if DevelopmentTools.clang_build_version <= 800
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0eedf78/libmwaw/ctor.patch"
      sha256 "1a443f16bf8918c642ce92c623c94ecc11198711c062ed0637ec36dd6ff6bb8b"
    end
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_document")
    # Test ID on an actual office document
    assert_equal shell_output("#{bin}/mwawFile #{testpath}/NEWSSLID.DOC").chomp,
                 "#{testpath}/NEWSSLID.DOC:Microsoft Word 2.0[pc]"
    # Control case; non-document format should return an empty string
    assert_equal shell_output("#{bin}/mwawFile #{test_fixtures("test.mp3")}").chomp,
                 ""
  end
end
