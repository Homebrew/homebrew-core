class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.3.0.tar.gz"
  sha256 "449cbc46556cc2cc9f9d6736904169a8df6415f6960528ee658998f96ca0e7cf"
  license "LGPL-2.1-or-later"
  revision 4

  livecheck do
    url "https://tangentsoft.com/mysqlpp/releases/"
    regex(/>mysql\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb03e282116800237c75a9374bb020f8cd9f6cd84b01a56549da52d595ff79e8"
    sha256 cellar: :any,                 arm64_sequoia: "5c39095c830382c0de716906058fdfc99dc8ba77c57b2682ffab177767790c21"
    sha256 cellar: :any,                 arm64_sonoma:  "20c4acc648555402a0e94e9d4f771ae4952e1a207ff86af5b088694b5bc0195d"
    sha256 cellar: :any,                 arm64_ventura: "40a3f055ec5b42ab64ed3996133d2250b4d01e35aadf3d4c156ed5c011708aaa"
    sha256 cellar: :any,                 sonoma:        "57348bc88e3ed7dfccd4c0b51a7c5416473a0e81d23eb6f9c863d21da02fa236"
    sha256 cellar: :any,                 ventura:       "5c9da073209c874fa0fd85f0d98783444e1af93e527871d7dc47366f22f9ab28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe9c4d8235e6b18d24d4c957347282d9c8a6476de38ac598568866d1b568fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05a8a2b24a6e5b63f6ed9b997686059ea081726bce22555a0665c4b19826effa"
  end

  depends_on "mariadb-connector-c"

  def install
    mariadb = Formula["mariadb-connector-c"]
    system "./configure", "--with-field-limit=40",
                          "--with-mysql=#{mariadb.opt_prefix}",
                          *std_configure_args

    # Delete "version" file incorrectly included as C++20 <version> header
    # Issue ref: https://tangentsoft.com/mysqlpp/tktview/4ea874fe67e39eb13ed4b41df0c591d26ef0a26c
    # Remove when fixed upstream
    rm "version"

    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <mysql++/cmdline.h>
      int main(int argc, char *argv[]) {
        mysqlpp::examples::CommandLine cmdline(argc, argv);
        if (!cmdline) {
          return 1;
        }
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{Formula["mariadb-connector-c"].opt_include}/mariadb",
                    "-L#{lib}", "-lmysqlpp", "-o", "test"
    system "./test", "-u", "foo", "-p", "bar"
  end
end
