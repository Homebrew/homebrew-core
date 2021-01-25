class Delta < Formula
  desc "Programmatically minimize files to isolate features of interest"
  homepage "https://web.archive.org/web/20170805142100/delta.tigris.org/"
  url "https://deb.debian.org/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  sha256 "38184847a92b01b099bf927dbe66ef88fcfbe7d346a7304eeaad0977cb809ca0"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "92e77d238cf7180260e1c176e7716760d3438a2b3dc713a64b2873c2a24ecfdd" => :big_sur
    sha256 "3cf5598409d5234d1c9c810a36cb3559b8b8ccdeb3593071435c3f6e7af7f64c" => :arm64_big_sur
    sha256 "244dfd6407c2b65ad33ca707b8642f51d5f63c8056ddd45baf5bc3734dc545ec" => :catalina
    sha256 "a6116fb7212cb2271b5c73c1bb53f51aeb33bfcc734e77bd42396a968744a42c" => :mojave
    sha256 "46734f3eb952455ecd9237ce455aebb3e66be791bbf190021d894dae39d55b66" => :high_sierra
    sha256 "07e775a1054966ad2924512386643bc8cb4ef3ad7e12ce9a140015c82fba3072" => :sierra
    sha256 "202409012500969cfd034c9d44c441a809445a3b367d514357346438aa850f14" => :el_capitan
    sha256 "d3374cc3e84c93bb84615b1669503ea8b708ab65baf629ee0be9a728b12b10bc" => :yosemite
    sha256 "04102ae55ffc2cc4351816b010544b854c21f1c5e2a462a6af0e57ec2f57b501" => :mavericks
  end

  conflicts_with "git-delta", because: "both install a `delta` binary"

  def install
    system "make"
    bin.install "delta", "multidelta", "topformflat"
  end

  test do
    (testpath/"test1.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int i = -1;
        unsigned int j = i;
        printf("%d\n", j);
      }

    EOS
    (testpath/"test1.sh").write <<~EOS
      #!/usr/bin/env bash

      clang -Weverything "$(dirname "${BASH_SOURCE[0]}")"/test1.c 2>&1 | \
      grep 'implicit conversion changes signedness'

    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/delta", "-test=test1.sh", "test1.c"
  end
end
