class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libffcall/libffcall-2.5.tar.gz"
  sha256 "7f422096b40498b1389093955825f141bb67ed6014249d884009463dc7846879"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fbe3ce6fb6c30092a721dbfcbcfbe662320e3cd25095ddbc486762494d53d4cb"
    sha256 cellar: :any,                 arm64_sequoia:  "e93c50e4766acad117fedb1330c4f90b07d0badda4f3d63aa9a19aa648ac4432"
    sha256 cellar: :any,                 arm64_sonoma:   "ec1b54aeab6d34a9ab35e7e376ed02847f08a29de71a3d4768fa96954327127c"
    sha256 cellar: :any,                 arm64_ventura:  "958171b0bcdc0974726cfff41c6de58c7e4f90017b4fb9d881b968e8d1612fdf"
    sha256 cellar: :any,                 arm64_monterey: "89ae257133dd08f737b51cafdbb62ee4aa5d6896d21f78e95673985a6639d265"
    sha256 cellar: :any,                 sonoma:         "39a00f8aa8c633d254f3dd8de7cd584e825a71d135b9ca3455dad8b1efe4169f"
    sha256 cellar: :any,                 ventura:        "ad7787776409d59f5b45119a6b799af71c09a7ab6f50970e4b563cb1b6d5e150"
    sha256 cellar: :any,                 monterey:       "d625f99cb896c08b3aeccfda72807c229e079f923f83be78a96d9d0433d47a03"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "12c0105ace9d81015418ec1ffb4226ba5b249c107c5dc0aa679a97b20afa4ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d42265685ccd225935b647212b027cabcf753fdd4c7f2596d9e30f3be1e8d40"
  end

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
