class Cscope < Formula
  desc "Tool for browsing source code"
  homepage "https://cscope.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz"
  sha256 "c5505ae075a871a9cd8d9801859b0ff1c09782075df281c72c23e72115d9f159"

  bottle do
    cellar :any_skip_relocation
    sha256 "212b5f945f2a2eae2d07893bb08c490098f4f3e58ec8865499bec550882de29e" => :catalina
    sha256 "0a8c76e372e2c965e654b5024cbf872931e6204b7e2ba79623d5d7d002cd3c2f" => :mojave
    sha256 "ae7b5f716debeb937c3472add41f69c7176e9c4a9a0668090afd63313eabbe86" => :high_sierra
    sha256 "7eef899511b0d7eb0d6a35acf677d9b19f89528aae0272d5c414bbafbe5daaaf" => :sierra
  end

  uses_from_macos "ncurses"

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
