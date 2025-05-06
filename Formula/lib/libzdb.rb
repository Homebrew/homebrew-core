class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.4.0.tar.gz"
  sha256 "abd675719bcbdde430aa4ee13975b980d55d2abcb5cc228082a30320a6bb9f0f"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2cdc0ace2bf1ef0a9d2526c7ae60e9274b89554b0c102fbec55e3de814644fe"
    sha256 cellar: :any,                 arm64_sonoma:  "64f246320a51ae3c3c964b5d43727117c86496dd00d3fa1502ffc5bd3b1dee2d"
    sha256 cellar: :any,                 arm64_ventura: "726e589d4f8923d5637a0e2e783646b72c27fc67be1b9964751a84756eff31f0"
    sha256 cellar: :any,                 sonoma:        "7edcecb1ca7c17d03534e6af574756ec864b4def522cb7e08eafe6b6644a726c"
    sha256 cellar: :any,                 ventura:       "241ebf0e383ea2e76a0f50a7631732196b766c2db21a7a9777dbfb698b099661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5298d25e7949700706d31195a5e6002340099bb67bda72a895f068cc5b8205a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c1a98b88d064a8046b123cd741283a5135edc37bac2567a650fdf561c9ed22"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
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
