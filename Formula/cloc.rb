class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/v1.70.tar.gz"
  sha256 "fd6e2bf95836578d8e94f2a85ce67f2e0cdf378b8200a02f8ee2a101f45984e9"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95d2733aa357872347ecd584c4e541b249ca3b3e2a53237725369d3c6b79c0e6" => :el_capitan
    sha256 "e21f1b24097805ec0de904b93fb26894980630caffd7b9e09efbcf0010df6126" => :yosemite
    sha256 "103095b754ef166c18b492c2e146130bf27e86a214f7a3fef68d942d52b20442" => :mavericks
  end

  def install
    system "make", "-C", "Unix", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
