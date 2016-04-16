class Cscope < Formula
  desc "Tool for browsing source code"
  homepage "http://cscope.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cscope/cscope/15.8b/cscope-15.8b.tar.gz"
  sha256 "4889d091f05aa0845384b1e4965aa31d2b20911fb2c001b2cdcffbcb7212d3af"

  bottle do
    cellar :any_skip_relocation
    sha256 "10c4cd802d68e0c552a99e86b0609b882664583e39b9c3ff44591832e75277e2" => :el_capitan
    sha256 "5625a04292cb85ee5ad70417db976aeb167b7b55c011f218d43febd2ee72b5c2" => :yosemite
    sha256 "c456f77835232efe5e3f9ed52885175266a039fbbc250afd9b6e646292c4b7d7" => :mavericks
    sha256 "80dbf0043c44a13d525b06096246e6ce493c1171d4b721cfa3828ac446e51831" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    (testpath/"cscope.files").write "./test.c\n"
    system "#{bin}/cscope", "-b", "-k"
    assert_match /test\.c.*func/, shell_output("#{bin}/cscope -L1func")
  end
end
