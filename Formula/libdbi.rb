class Libdbi < Formula
  desc "Database-independent abstraction layer in C, similar to DBI/DBD in Perl"
  homepage "https://libdbi.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libdbi/libdbi/libdbi-0.9.0/libdbi-0.9.0.tar.gz"
  sha256 "dafb6cdca524c628df832b6dd0bf8fabceb103248edb21762c02d3068fca4503"

  bottle do
    sha256 "7973069acb7729030c077efdd82e376d798725739180434b85798022c5f80daf" => :mojave
    sha256 "bfbfbb4a406e11bc76f0bb590923fe2c9c5ecb8eee2ad59c115bf5d8fe9fc83b" => :high_sierra
    sha256 "56bc34833d44be61b26fda170fd8c2eea6242d6cfc780869d9456dcee6fb9e41" => :sierra
    sha256 "80593f395134244612e570445f7dafaede45632025f25a079d2978ea8ceced93" => :el_capitan
    sha256 "fdc8341304e7a5b08f8baa86019c0b75d9bea99b7461f1eafc32f906a446b49a" => :yosemite
    sha256 "105af923e45a1deb810224f39ecd138442943dfef193636414bf1394982c01ea" => :mavericks
    sha256 "44c30231f8c33cb67eae20b8078528c743e180bf549b940cf20598a551b46b6b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dbi/dbi.h>
      int main(void) {
        dbi_inst instance;
        dbi_initialize_r(NULL, &instance);
        printf("dbi version = %s\\n", dbi_version());
        dbi_shutdown_r(instance);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldbi", "-o", "test"
    system "./test"
  end
end
