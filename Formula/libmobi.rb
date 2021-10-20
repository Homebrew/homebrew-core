class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.8/libmobi-0.8.tar.gz"
  sha256 "3116125039493c4a1009e32d014d84cc1808674d49a5aecf89bff6433d8387e4"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c457b6ace79b52c67aa29a2fa6a95efa542104bc263bca7a1d79f519fb34ddcd"
    sha256 cellar: :any,                 big_sur:       "03942b017ce950187f2950fd8612e7d5c3ddb4541e4a48344f8dd7f9adb306dc"
    sha256 cellar: :any,                 catalina:      "eea4fc062b119d7a420e1e511cb000927976fc56cc3cfda77e95f2224cc71b57"
    sha256 cellar: :any,                 mojave:        "33ad38a4a40187f9aa20dec2e9f153102f3ac961cf619686698bf7d23d9142e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3adb5a02f5c65985cd7f3341a4068e178513c4bd1038ecd76b1a0141210de13a"
  end

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
