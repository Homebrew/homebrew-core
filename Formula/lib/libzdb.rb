class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.3.tar.gz"
  sha256 "a1957826fab7725484fc5b74780a6a7d0d8b7f5e2e54d26e106b399e0a86beb0"
  license "GPL-3.0-only"
  revision 6

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd97a7dd6aefe7e58b341a5358edfb32b66bba0f1cb8630b399f2b02700d09bb"
    sha256 cellar: :any,                 arm64_sonoma:  "559a24c293383d393cf10674d80dc3dc2c11ba7e8ddc49fd946a5ef22956284d"
    sha256 cellar: :any,                 arm64_ventura: "a6dd1911a57055a2166194a5d6d96511c66a9b33d471ea5de332521a6fd45fb3"
    sha256 cellar: :any,                 sonoma:        "1bdf664002cbd63f8fce912432760eee51ca3b3836462ab7698fa9b1066a2e13"
    sha256 cellar: :any,                 ventura:       "4ec2d9cad1a1461b597fb6dcd0ebf9087ca0afcb9e1532a666f4278bcc767df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4c23875500da4ada769975cf4857752db3e0a45f5c99553d008ae14282a72d"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mariadb-connector-c"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-silent-rules", "--enable-sqliteunlock", *std_configure_args
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
