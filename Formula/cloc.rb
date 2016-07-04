class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/v1.70.tar.gz"
  sha256 "fd6e2bf95836578d8e94f2a85ce67f2e0cdf378b8200a02f8ee2a101f45984e9"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73e94bf311ad9d6e96b6257e7d5db37fda630d3b9beee0d1332ee7a274f23b67" => :el_capitan
    sha256 "977fc57cdec9172b3a2948b862a95a5f3ef9ecb301ca55e614b56f8a3d64c90c" => :yosemite
    sha256 "12bfa1e13c517e2c90ce0de1a5d5e468486f1191445b6ac19c7d9ad7be883ea9" => :mavericks
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
