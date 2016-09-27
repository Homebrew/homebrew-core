class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.4.0/libxmp-lite-4.4.0.tar.gz"
  sha256 "34173c021dc5a6b10ac73abbf4d34d7adbbe8d95c6fa80fb92d9399b83423cdb"

  bottle do
    cellar :any
    sha256 "1266efbd12e4ae237b9e5c680ec2811c91edd9676b8c112175fc92e782e25f21" => :sierra
    sha256 "4fed865546c6b743738eb0a954ffec64979c94f901a5ebd9db6abd1f60394380" => :el_capitan
    sha256 "0fadd923ffad8f89d0cd8474d1fd0a022bc966a7a346a5063e62555d09b36c52" => :yosemite
    sha256 "dfe9f20c4ecd19e7eda3517737015f58201115334bf2145b0c21ef4b0bab252c" => :mavericks
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
