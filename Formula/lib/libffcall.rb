class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftpmirror.gnu.org/libffcall/libffcall-2.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libffcall/libffcall-2.6.tar.gz"
  sha256 "7e3951d642a1884adaf7f15c60df1bf8fbde686daa9fa69df1a514471b8cff39"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    manifest_sha256 "a6e0eccf586a8d32ea1ee514e820fbd3d8f3fec8711e53443aeb57a3a0d1eaab"
    sha256 cellar: :any, arm64_golden_gate: "77729a92694af90b17873ca592d21a468a06a1054c1029b2551ad9a767758bc3"
    sha256 cellar: :any, arm64_tahoe:       "43b81e5f5874e3fe1fba31e6e5c7dcc4d0674d8c0cfc0c1c0449b9e810118ea8"
    sha256 cellar: :any, arm64_sequoia:     "b4db7f982f859bd96dbfdfa774eebdbe775e920ed8c719e4e6e4e254aaa4e95f"
    sha256 cellar: :any, arm64_linux:       "e91715c47088a1d58752e14df1b3f7151b906bd1ba4b423ea9030267afd8eb33"
    sha256 cellar: :any, x86_64_linux:      "6806137374966f0e35097bf9e5704795f0809c06398aed1a4f86414ed1f31419"
  end

  conflicts_with "epics-base", because: "both install `callback.h` header"

  deny_network_access!

  def install
    ENV.deparallelize
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"callback.c").write <<~C
      #include <stdio.h>
      #include <callback.h>

      typedef char (*char_func_t) ();

      void function (void *data, va_alist alist)
      {
        va_start_char(alist);
        va_return_char(alist, *(char *)data);
      }

      int main() {
        char *data = "abc";
        callback_t callback = alloc_callback(&function, data);
        printf("%s\\n%c\\n",
          is_callback(callback) ? "true" : "false",
          ((char_func_t)callback)());
        free_callback(callback);
        return 0;
      }
    C
    flags = ["-L#{lib}", "-lffcall", "-I#{lib}/libffcall-#{version}/include"]
    system ENV.cc, "-o", "callback", "callback.c", *(flags + ENV.cflags.to_s.split)
    output = shell_output("#{testpath}/callback")
    assert_equal "true\na\n", output
  end
end
