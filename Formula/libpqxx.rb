class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.7.2.tar.gz"
  sha256 "4b7a0b67cbd75d1c31e1e8a07c942ffbe9eec4e32c29b15d71cc225dc737e243"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fe1aa09e787c6a6ef9f9d18cba4a941defd84abc0d7587383bf82300c9101a18"
    sha256 cellar: :any,                 arm64_big_sur:  "88de1e1f59c011cccf76a6a3fcd4352b20803b6b191eee9658d5ef1ce8b2bbe7"
    sha256 cellar: :any,                 monterey:       "c143db5c27b7e7dc30bcba40f1465b58e68fcf8b2fd1de9d651a9598355ab033"
    sha256 cellar: :any,                 big_sur:        "5f4d16846e7590e7697e0aa5ad620cf559867c14bd99f4f9371f5369ab933312"
    sha256 cellar: :any,                 catalina:       "567272fec74fd895f9d2c37686af837ee1dcb0b610a766b19e84889d83147421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e427ded0fcd5f22b8069b17cb1a264cdfbe88fe8de92b8f97807b305f782e98b"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
