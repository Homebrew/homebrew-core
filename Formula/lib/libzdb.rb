class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.5.0.tar.gz"
  sha256 "90c79bf23b0c8fcb6543634844d17c094a24a360c9d63ddf6efc3741ebec32c5"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e823552985e05bb6f5506fa3cead177bc8e2f388342567efb731e53f10f5c9e7"
    sha256 cellar: :any,                 arm64_sequoia: "fce519ab90a9ed0c1a753df628afed46f7e9079532c87a366b5f1bdd06ae0503"
    sha256 cellar: :any,                 arm64_sonoma:  "d7f4b9d1ff186e53c0f57201471a3cff895c8006a9a6d3a49c2687590acfb495"
    sha256 cellar: :any,                 sonoma:        "37fa3aac2e71b2319ffeac999a72baecf86194484e4a663beba0cdc6417cf25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e309f3c47a01f6cfda5b621e4d358048f22201f973df4615163eacbd3422e47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7f359cdb4916f44128b64c324d27915dec76d917d380509ab05ffc11e869ddb"
  end

  depends_on "libpq"
  depends_on "mariadb-connector-c"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-silent-rules", "--enable-protected", "--enable-sqliteunlock", *std_configure_args
    system "make", "install"
    (pkgshare/"test").install Dir["test/*.{c,cpp}"]
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system ENV.cc, "select.c", "-L#{lib}", "-lpthread", "-lzdb", "-I#{include}/zdb", "-o", "select"
      system "./select"
    end
  end
end
