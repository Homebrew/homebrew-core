class Marisa < Formula
  desc "Matching Algorithm with Recursively Implemented StorAge"
  homepage "https://github.com/s-yata/marisa-trie"
  url "https://github.com/s-yata/marisa-trie/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "1063a27c789e75afa2ee6f1716cc6a5486631dcfcb7f4d56d6485d2462e566de"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e875c402f816ea59607b35dfaba1ca3556934b77f3adf9522a662b474a531de"
    sha256 cellar: :any,                 arm64_sonoma:  "71fa0487725231a5d3c5d53f7564279b4f40d684939392d90f2d446502304666"
    sha256 cellar: :any,                 arm64_ventura: "96d9aac1c7bd7c4f0d927619215b2216791f83ed80693b86706e0077062dfe81"
    sha256 cellar: :any,                 sonoma:        "89899d1173f4dcacc825068599a458c818f42c9ff2c6ae9dccac56a0eec837e6"
    sha256 cellar: :any,                 ventura:       "fc0d60913ac0333a5dc9f977e77f466388b5484c8e77cf190e80c48b582f9deb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85694a17eae4c73ae6a61c691bc6fa526a662389bc215decaf9e2d4cd97465c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45455df30c80232d1c7d16146b550fea52fbd71d0bc341bdbe3acae2038b4286"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <cstdlib>
      #include <cstring>
      #include <ctime>
      #include <string>
      #include <iostream>
      #include <vector>

      #include <marisa.h>

      int main(void)
      {
        int x = 100, y = 200;
        marisa::swap(x, y);
        std::cout << x << "," << y << std::endl;
      }
    CPP

    system ENV.cxx, "./test.cc", "-o", "test"
    assert_equal "200,100", shell_output("./test").strip
  end
end
