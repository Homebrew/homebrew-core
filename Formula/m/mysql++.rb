class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.3.0.tar.gz"
  sha256 "449cbc46556cc2cc9f9d6736904169a8df6415f6960528ee658998f96ca0e7cf"
  license "LGPL-2.1-or-later"
  revision 3

  livecheck do
    url "https://tangentsoft.com/mysqlpp/releases/"
    regex(/>mysql\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "5b06b157f278d4298095325e3a05118a1293fff3f542494ec594cb847fe88261"
    sha256 cellar: :any,                 arm64_sonoma:   "feb7078de4fa2eabd483aa1e96a40f76a3194e964996f7e933ee9064074ead84"
    sha256 cellar: :any,                 arm64_ventura:  "7733ee0ff347f47c24396f16366af6b46ac8ef02542b9cb8d85136d9a8c17c6b"
    sha256 cellar: :any,                 arm64_monterey: "c0c11ebc7004bae617aeafa1bc621761e829401e8763c0e89d9e3045e3d83eb2"
    sha256 cellar: :any,                 sonoma:         "635f18063d29b4a49b363c7637584a5c4a1ee624fa06a5bd7c1a02187ae8b799"
    sha256 cellar: :any,                 ventura:        "1f498501658bd1f0ddeac3543ed35bd4a5eac3a26b436337b0d751abc390cf12"
    sha256 cellar: :any,                 monterey:       "65dbdf422828f065d912f678f31606de6a808e43373aac6c1e5aca0ca491b4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "243beca649ebb4da087364acf8a7a10005d2e595e7513828e7397a45ffdc8ec5"
  end

  depends_on "mysql-client"

  fails_with gcc: "5"

  def install
    mysql = Formula["mysql-client"]
    system "./configure", "--with-field-limit=40",
                          "--with-mysql-lib=#{mysql.opt_lib}",
                          "--with-mysql-include=#{mysql.opt_include}/mysql",
                          *std_configure_args

    # Delete "version" file incorrectly included as C++20 <version> header
    # Issue ref: https://tangentsoft.com/mysqlpp/tktview/4ea874fe67e39eb13ed4b41df0c591d26ef0a26c
    # Remove when fixed upstream
    rm "version"

    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mysql++/cmdline.h>
      int main(int argc, char *argv[]) {
        mysqlpp::examples::CommandLine cmdline(argc, argv);
        if (!cmdline) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["mysql-client"].opt_include}/mysql",
                    "-L#{lib}", "-lmysqlpp", "-o", "test"
    system "./test", "-u", "foo", "-p", "bar"
  end
end
