class Cscope < Formula
  desc "Tool for browsing source code"
  homepage "https://cscope.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz"
  sha256 "c5505ae075a871a9cd8d9801859b0ff1c09782075df281c72c23e72115d9f159"

  bottle do
    cellar :any_skip_relocation
    sha256 "d13055e5d40c7b29ca273be19d611db2d9c157198bddbaf85bf6ca58323e0dc4" => :mojave
    sha256 "c341d01145d24da1e42347e3c8924569e97158c826ab5a118c2708baa3733ecc" => :high_sierra
    sha256 "7065f35c7c69268a0c293c7108e936c92c83fa6c1aff78d9fb6eb4d6178cb3c9" => :sierra
    sha256 "97930be35cbcd08980651597acf931adbb50a80df10960d6564497f19d9c8032" => :el_capitan
    sha256 "71d86771790165c777341e4457dd193008cfb2fb24628a138cb45fec61e6b42d" => :yosemite
    sha256 "cb2f63522d072307cacf63e8eabf4c284f2e8c1b2ff8c6de3aeb6fb8759a1212" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
