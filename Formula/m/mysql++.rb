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
    sha256 cellar: :any,                 arm64_sonoma:   "95302e1f418e66a49e6319092fd07ead89002dacada0fa0f0599d1b9207272b6"
    sha256 cellar: :any,                 arm64_ventura:  "eecf11305d9b3b60433b3b35ee9e61d302a00069e9154b5ee3a7295197fbc75c"
    sha256 cellar: :any,                 arm64_monterey: "4b533297eb952a04d97fc90ebfc3238b77b0b545fa714f9dbbf311df636cfde6"
    sha256 cellar: :any,                 sonoma:         "9a801ba67ace648909f12a6e761688e471c449eb7ff20cafd7e11bea2e3e8782"
    sha256 cellar: :any,                 ventura:        "80e894a5469e61b2c95fb0d8bbf14562059bdbb4c7d615c5f38d8d569199c736"
    sha256 cellar: :any,                 monterey:       "4c26b0222a2ef150ba390c3004f4691ff9dc8591b4ed4479eed0aee5871c0f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76988d129aaec0463f1aff16280ac948243f33f366e2a6466c894819173b7387"
  end

  depends_on "mysql-client@8.0" # Does not build with > 8.3: https://tangentsoft.com/mysqlpp/tktview/703152e2da

  fails_with gcc: "5"

  def install
    mysql = Formula["mysql-client@8.0"]
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{mysql.opt_lib}",
                          "--with-mysql-include=#{mysql.opt_include}/mysql"

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
    system ENV.cxx, "test.cpp", "-I#{Formula["mysql-client@8.0"].opt_include}/mysql",
                    "-L#{lib}", "-lmysqlpp", "-o", "test"
    system "./test", "-u", "foo", "-p", "bar"
  end
end
