class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.6.tar.gz",
      :using => :nounzip
  sha256 "3b99665c4f0dfda31d200bf2528540d6898cb846499ee91effa2e8f72aff3a60"
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84bb08cf8c454272c7bfa95f530dc8f8bc15af43748631704dc7321f2989226c" => :catalina
    sha256 "cef55345cf5a32b30aa7d9a320b3143eb05b5f8329a8abbfad2a247622ab233f" => :mojave
    sha256 "cf2689471e033bb6e55cd948679eef30c9abecb17f022fc6cb914fbe0ca85c6d" => :high_sierra
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :sierra
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :el_capitan
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :yosemite
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Remove for > 1.6
    # Fix "deheader-1.6/deheader.1: Can't create 'deheader-1.6/deheader.1'"
    # See https://gitlab.com/esr/deheader/commit/ea5d8d4
    system "/usr/bin/tar", "-xvqf", "deheader-1.6.tar.gz",
                           "deheader-1.6/deheader.1"
    system "/usr/bin/tar", "-xvf", "deheader-1.6.tar.gz", "--exclude",
                           "deheader-1.6/deheader.1"
    cd "deheader-1.6" do
      system "make"
      bin.install "deheader"
      man1.install "deheader.1"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      int main(void) {
        printf("%s", "foo");
        return 0;
      }
    EOS
    assert_equal "121", shell_output("#{bin}/deheader test.c | tr -cd 0-9")
  end
end
