class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.26.1.tar.gz"
  sha256 "385956d63bfc8169f5dcc2eced316c2997e9b41962918bd86bb345b43eca5868"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a50f4f7e7dabafd0ea8d25e3b884d7bf8d908c4e0206b6a4bde726cd806be43e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d321a0b08fd7f33771f8cec364499a48e7fd08f7ab7b093757f97f1833dd3fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cba777248486e05ee0d905604c1324fb5b3ed6845df3ac56e127fdb3be143ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "69272b7b6cfd7cf05c97e634a954760c5a3cdb5192b2a416eeff38140b2519d0"
    sha256 cellar: :any_skip_relocation, ventura:       "90ad8d1d3b0e94f07641c745b7fbf3162d6c353fb95ea0d87682324fdbe466ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bdaf807097e0c0b0f78b23a0e0c35788f8f09ea7433011196171a6900a5e994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c1b757b222947d219644e8718410a5bdbd5965c66090cf50689cd0c336d1f5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';\n", (testpath/"unformatted.php").read
  end
end
