class Aflplusplus < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/vanhauser-thc/AFLplusplus"
  url "https://github.com/vanhauser-thc/AFLplusplus/archive/2.60c.tar.gz"
  sha256 "8b82c585c255f87536a7aef76da635d72675d75674dfc017dfe2e0d8d8bf397b"

  depends_on "wget"
  depends_on "automake"

  conflicts_with "afl-fuzz"

  patch :DATA

  def install
    system "make", "distrib", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end

__END__
# install -D flag unsupported plus those man pages are only for fast mode anyway.
diff --git a/Makefile b/Makefile
index f287a3a..7aff616 100644
--- a/Makefile
+++ b/Makefile
@@ -400,7 +400,6 @@ endif
 	set -e; if [ -f afl-clang-fast ] ; then ln -sf afl-clang-fast $${DESTDIR}$(BIN_PATH)/afl-clang ; ln -sf afl-clang-fast $${DESTDIR}$(BIN_PATH)/afl-clang++ ; else ln -sf afl-gcc $${DESTDIR}$(BIN_PATH)/afl-clang ; ln -sf afl-gcc $${DESTDIR}$(BIN_PATH)/afl-clang++; fi
 
 	mkdir -m 0755 -p ${DESTDIR}$(MAN_PATH)
-	install -m0644 -D *.8 ${DESTDIR}$(MAN_PATH)
 
 	install -m 755 afl-as $${DESTDIR}$(HELPER_PATH)
 	ln -sf afl-as $${DESTDIR}$(HELPER_PATH)/as
