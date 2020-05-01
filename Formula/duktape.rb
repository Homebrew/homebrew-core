class Duktape < Formula
  desc "Embeddable Javascript engine with compact footprint"
  homepage "https://duktape.org"
  url "https://duktape.org/duktape-2.5.0.tar.xz"
  sha256 "83d411560a1cd36ea132bd81d8d9885efe9285c6bc6685c4b71e69a0c4329616"

  def install
    inreplace "Makefile.sharedlibrary" do |s|
      s.gsub! %r{\/usr\/local}, prefix
    end
    system "make", "-f", "Makefile.sharedlibrary"
    system "make", "-f", "Makefile.sharedlibrary", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <stdio.h>
      #include \"duktape.h\"
      int main(int argc, char *argv[]) {
        duk_context *ctx = duk_create_heap_default();
        duk_eval_string(ctx, \"1+2\");
        printf(\"1+2=%d\\n\", (int) duk_get_int(ctx, -1));
        duk_destroy_heap(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lduktape",
           testpath/"test.cc", "-o", testpath/"test"
    assert_equal "1+2=3", shell_output(testpath/"test").strip, "Duktape can add number"
  end
end
