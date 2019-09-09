class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.tar.gz"
  sha256 "005ddf4b29c6db622e16303298c2f914dfd82590111cea7cfd09b4acf46cf4f2"
  revision 1

  bottle do
    cellar :any
    sha256 "d35ba4a4e51728b8972bc4fd81d36cc705cbd11361da4b79071f6e623d93911f" => :mojave
    sha256 "55b4039e6d15b5403830d74c40194e2c33644d47e001c143c21af77f0ef02e79" => :high_sierra
  end

  depends_on :macos => :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
