class Libdbi < Formula
  desc "Database-independent abstraction layer in C, similar to DBI/DBD in Perl"
  homepage "https://libdbi.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libdbi/libdbi/libdbi-0.9.0/libdbi-0.9.0.tar.gz"
  sha256 "dafb6cdca524c628df832b6dd0bf8fabceb103248edb21762c02d3068fca4503"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ce66e90000681c5f9174c3698ac4ceefd5d1be6ca4ffa574053f0705217c6837" => :catalina
    sha256 "3aff10515535dc3f99dfa56644229daba74f719838d3e580754b3bbdc3c0429d" => :mojave
    sha256 "eb3d8474601267d835b74b5a29944dc6d987486745dcfd17389be3a44b2c0175" => :high_sierra
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
