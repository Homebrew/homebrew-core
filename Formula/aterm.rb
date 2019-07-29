class Aterm < Formula
  desc "Annotated Term for tree-like ADT exchange"
  homepage "https://strategoxt.org/Tools/ATermFormat"
  url "http://www.meta-environment.org/releases/aterm-2.8.tar.gz"
  sha256 "bab69c10507a16f61b96182a06cdac2f45ecc33ff7d1b9ce4e7670ceeac504ef"

  bottle do
    cellar :any
    rebuild 1
    sha256 "302f12e90b83e896318e34a1931cdee75d7de43d1c8de9163f307a9d17f1668c" => :mojave
    sha256 "f56a13be464fa577fdad7fe82779f5e6bbe820995e1849b6741ca92807c10bf0" => :high_sierra
    sha256 "dd7b81b3bd9a31746ab461b8d79e4c32838b7e86f540769e4c17825a4b89c1c2" => :sierra
    sha256 "5140e20287eda941f8756dfdaf377663f84f6872d1ca3f6d70e04b554591d11a" => :el_capitan
    sha256 "d12bebbfa2e764abb9cfac1aecd6fc04e58f83eadf0fb3db298d5be03d7f8dca" => :yosemite
    sha256 "f565d64b5b19b549cfe6eacedd587ff6d2b0e0b3129e1018b364edc0c2d9c415" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.deparallelize # Parallel builds don't work
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <aterm1.h>

      int main(int argc, char *argv[]) {
        ATerm bottomOfStack;
        ATinit(argc, argv, &bottomOfStack);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lATerm", "-o", "test"
    system "./test"
  end
end
