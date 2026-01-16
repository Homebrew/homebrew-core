class Libthai < Formula
  desc "Thai language support library"
  homepage "https://linux.thai.net/projects/libthai"
  url "https://linux.thai.net/pub/thailinux/software/libthai/libthai-0.1.30.tar.xz"
  sha256 "ddba8b53dfe584c3253766030218a88825488a51a7deef041d096e715af64bdd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "683257ceaae0ebf522c07e2fd39b82863ff54d35ac8a985d9d62597bda8a05b3"
    sha256 arm64_sequoia: "428726b804e7bb80faef7381ba27b0be1a0087e54746d0f355c0af7575220ac6"
    sha256 arm64_sonoma:  "e969faf14de2c64bcd89e1e1abea14d12d8695eba54647782e2e841042b3209d"
    sha256 sonoma:        "151b8c0772dce394bc4c1112d90b45999d18be1b0406abf322be74f5976cf63a"
    sha256 arm64_linux:   "424e3a5b178a1eaf5cd0c9d56bfd3671c316cd88096e9297d407836c826d5296"
    sha256 x86_64_linux:  "54551ab441971407573f2f97d085cd26ec3b61eda8fbf6d599ce2a41bfdb5f02"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libdatrie"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-doxygen-doc",
                          *std_configure_args

    system "make"
    system "make", "install"
  end

  test do
    # Basic linkage test to ensure the library is installed and usable
    (testpath/"test.c").write <<~EOS
      #include <thai/thctype.h>
      #include <stdio.h>

      int main() {
          // 0xa1 is KO KAI in TIS-620 encoding
          if (th_isthai(0xa1)) {
              return 0;
          }
          return 1;
      }
    EOS
    flags = shell_output("pkgconf --cflags --libs libthai").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
