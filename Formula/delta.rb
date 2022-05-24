class Delta < Formula
  desc "Programmatically minimize files to isolate features of interest"
  homepage "https://web.archive.org/web/20170805142100/delta.tigris.org/"
  url "https://deb.debian.org/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  sha256 "38184847a92b01b099bf927dbe66ef88fcfbe7d346a7304eeaad0977cb809ca0"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a929cf7113873c9fb9d4f9d05fa8e522299a617586c3c4f7bc756629b4eb77d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cf5598409d5234d1c9c810a36cb3559b8b8ccdeb3593071435c3f6e7af7f64c"
    sha256 cellar: :any_skip_relocation, monterey:       "bab82bd6e0d4cd2b4815a06cc7854c38d7d957fbad255168c29c0deb5022ec40"
    sha256 cellar: :any_skip_relocation, big_sur:        "92e77d238cf7180260e1c176e7716760d3438a2b3dc713a64b2873c2a24ecfdd"
    sha256 cellar: :any_skip_relocation, catalina:       "244dfd6407c2b65ad33ca707b8642f51d5f63c8056ddd45baf5bc3734dc545ec"
    sha256 cellar: :any_skip_relocation, mojave:         "a6116fb7212cb2271b5c73c1bb53f51aeb33bfcc734e77bd42396a968744a42c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "46734f3eb952455ecd9237ce455aebb3e66be791bbf190021d894dae39d55b66"
    sha256 cellar: :any_skip_relocation, sierra:         "07e775a1054966ad2924512386643bc8cb4ef3ad7e12ce9a140015c82fba3072"
    sha256 cellar: :any_skip_relocation, el_capitan:     "202409012500969cfd034c9d44c441a809445a3b367d514357346438aa850f14"
    sha256 cellar: :any_skip_relocation, yosemite:       "d3374cc3e84c93bb84615b1669503ea8b708ab65baf629ee0be9a728b12b10bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b9fd96832e66748aaa61cf7a9b735275931a80c9f46a714b347889de5cc332"
  end

  deprecate! date: "2022-04-30", because: :unmaintained

  conflicts_with "git-delta", because: "both install a `delta` binary"

  def install
    system "make"
    bin.install "delta", "multidelta", "topformflat"
  end

  test do
    (testpath/"test1.c").write <<~EOS
      int main() {
        printf("%d\n", 0);
      }
    EOS
    (testpath/"test1.sh").write <<~EOS
      #!/usr/bin/env bash

      #{ENV.cc} -Wall #{testpath}/test1.c 2>&1 | grep 'Wimplicit-function-declaration'
    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/delta", "-test=test1.sh", "test1.c"
  end
end
