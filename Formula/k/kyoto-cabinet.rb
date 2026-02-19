class KyotoCabinet < Formula
  desc "Library of routines for managing a database"
  homepage "https://dbmx.net/kyotocabinet/"
  url "https://dbmx.net/kyotocabinet/pkg/kyotocabinet-1.2.80.tar.gz"
  sha256 "4c85d736668d82920bfdbdb92ac3d66b7db1108f09581a769dd9160a02def349"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://dbmx.net/kyotocabinet/pkg/"
    regex(/href=.*?kyotocabinet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "8c03d0a70b2156784bf4db81491d582b8dd5791125a5621a00d9cdbd5d34da4e"
    sha256 arm64_sequoia: "e6e743ed4be2b0c94966e6622276884fe654cb266caff7f1899d09486100302a"
    sha256 arm64_sonoma:  "5f81a814035a2afa3c5c2be4d7325553120d5f4763b0d48e602d0de7e6ec89f7"
    sha256 tahoe:         "2261bfbe90c66ff5c815c1e33e3e16edd00171bdd37303e5fa12138d03be63ff"
    sha256 sequoia:       "9054f01ed121864136b78604cf4f3fa963d87d550df738d7a6eccd71ac4e7909"
    sha256 sonoma:        "1eec27e4a7aa9f4f345ee8c2c4025551b4d195013b6e001028d03ddbd3845d8e"
    sha256 arm64_linux:   "12244c6b610c93626dd6163c17077439df64c9390f11f145ad94392bee33dffd"
    sha256 x86_64_linux:  "c8fab699165ea045c5067847edb04c38d8b7326ad4cf0936031d93838709944e"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch :DATA

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["zlib-ng-compat"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["zlib-ng-compat"].opt_lib}"
    end
    ENV.cxx11
    system "./configure", *std_configure_args
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    # https://dbmx.net/kyotocabinet/spex.html#tutorial_kchashmgr
    system bin/"kchashmgr", "create", "staffs.kch"
    system bin/"kchashmgr", "set", "staffs.kch", "1001", "George Washington"
    system bin/"kchashmgr", "set", "staffs.kch", "1002", "John Adams"
    system bin/"kchashmgr", "set", "staffs.kch", "1003", "Thomas Jefferson"
    system bin/"kchashmgr", "set", "staffs.kch", "1004", "James Madison"
    assert_equal <<~EOS, shell_output("#{bin}/kchashmgr list -pv staffs.kch")
      1001\tGeorge Washington
      1002\tJohn Adams
      1003\tThomas Jefferson
      1004\tJames Madison
    EOS
  end
end


__END__
--- a/kccommon.h  2013-11-08 09:27:37.000000000 -0500
+++ b/kccommon.h  2013-11-08 09:27:47.000000000 -0500
@@ -82,7 +82,7 @@
 using ::snprintf;
 }

-#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER)
+#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER) || defined(_LIBCPP_VERSION)

 #include <unordered_map>
 #include <unordered_set>
