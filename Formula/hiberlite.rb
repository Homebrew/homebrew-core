class Hiberlite < Formula
  desc "C++ ORM for SQLite"
  homepage "https://github.com/paulftw/hiberlite"
  head "https://github.com/paulftw/hiberlite.git"

  depends_on "sqlite"

  def install
    if build.bottle?
      lib.mkpath
      lib.install "1e41fc2/lib/libhiberlite.a"
      (lib/"pkgconfig").mkpath
      (lib/"pkgconfig").install "1e41fc2/lib/pkgconfig/libhiberlite.pc"
      include.install "1e41fc2/include/hiberlite"
    else
      system "make", "INSTALL_PREFIX=#{prefix}"
      system "make", "install",
                     "INSTALL_PREFIX=#{prefix}"
      (lib+"pkgconfig/libhiberlite.pc").write pc_file
    end
  end

  def pc_file; <<-EOS.undent
    prefix=#{prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include
    ldflags=  -L${prefix}/lib

    Name: libhiberlite
    Description: Hiberlite library
    Version: #{version}

    Requires:
    Libs: -L${libdir} -lhiberlite
    Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "hiberlite/hiberlite.h"
      int main() {
          hiberlite::Database db("test.db");
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lhiberlite"
    assert (testpath/"test").exist?, "Compiling with libhibernate is failed."
    system "./test"
    assert (testpath/"test.db").exist?, "Hiberlate could not create a database."
  end
end
