class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.4.1/libxmp-lite-4.4.1.tar.gz"
  sha256 "bce9cbdaa19234e08e62660c19ed9a190134262066e7f8c323ea8ad2ac20dc39"

  bottle do
    cellar :any
    sha256 "1266efbd12e4ae237b9e5c680ec2811c91edd9676b8c112175fc92e782e25f21" => :sierra
    sha256 "4fed865546c6b743738eb0a954ffec64979c94f901a5ebd9db6abd1f60394380" => :el_capitan
    sha256 "0fadd923ffad8f89d0cd8474d1fd0a022bc966a7a346a5063e62555d09b36c52" => :yosemite
    sha256 "dfe9f20c4ecd19e7eda3517737015f58201115334bf2145b0c21ef4b0bab252c" => :mavericks
  end

  # Remove for > 4.4.1
  # Fix build failure "dyld: Symbol not found: _it_loader"
  # Upstream commit "libxmp-lite building (wrong format loaders)"
  # Already in master. Original PR 6 Nov 2016 https://github.com/cmatsuoka/libxmp/pull/82
  patch :p2 do
    url "https://github.com/cmatsuoka/libxmp/commit/a028835.patch"
    sha256 "68eb66e6a8c799376f7bb2d9d96bfa8d26470ad5706d6c0cdb774d05dbbc0c15"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-'EOS'.undent
      #include <stdio.h>
      #include <libxmp-lite/xmp.h>

      int main(int argc, char* argv[]){
        printf("libxmp-lite %s/%c%u\n", XMP_VERSION, *xmp_version, xmp_vercode);
        return 0;
      }
    EOS

    system ENV.cc, "-I", include, "-L", lib, "-lxmp-lite", "test.c", "-o", "test"
    system "#{testpath}/test"
  end
end
