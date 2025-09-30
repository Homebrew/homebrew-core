class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.4.1.tar.gz"
  sha256 "5b4633fc2a16880f776197f4045f62ef8db5062f63030fa221011d4b85d736cb"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de6f49922942aa7eedef7a3be73e0ee108942d81126134c0c0cfb71ca585637e"
    sha256 cellar: :any,                 arm64_sequoia: "7ada18691b69fb2fe14cbc26b6e37acc064386f8126d94ce2ee52bc1a33d1aa4"
    sha256 cellar: :any,                 arm64_sonoma:  "ca0e3601cb111cc6c2bd04831af5c9d18a8ae39297bc89f16d53c0678c1cad51"
    sha256 cellar: :any,                 arm64_ventura: "11174fffce669dbc8386dac012f4594500fdd596c4886801bad1e8ebd28ab77d"
    sha256 cellar: :any,                 sonoma:        "1843cd80847c08ddfa3ae8eb7b9e9a9d2a32969b34c20ece74cac56ce273e152"
    sha256 cellar: :any,                 ventura:       "dc8fbe5b6fba579fbaf7f628f73aee6b483fa3a3ecda5716275deda4cb3f7ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f77c7ceb5a775daee1b96ddf92589067dcfaf462b074d44cabcf646bd97fd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9551416d8cb38c1aaef90512c88a72fa5516b4db4dc3abb46c9267fb12f2181f"
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
