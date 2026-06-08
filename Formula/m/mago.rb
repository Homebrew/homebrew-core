class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.30.0/source-code.tar.gz"
  sha256 "aa2d1ff13165706a73c5202231a3c792a97cfb613bd41ee9d0e6097af6a20e06"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0d07a65e798d5955f5ecfec610290a3c75b51cea3aa3f85046b0d62da7f9749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab884fd422c28a500c384add6cab40bd0b1723d575874e974dd81442f02583f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a933eeef2e30ea995ea9accc462ef0c9ec952a48a987029083563e8da29c1c51"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aba25050e44be746627200213787b6a99c7bf0eec2a2ab71eeb4148572ff9ac"
    sha256 cellar: :any,                 arm64_linux:   "0265ccb6ba11db215f51b13dc2e358dedf065af61552b4d1d2d14abed2796506"
    sha256 cellar: :any,                 x86_64_linux:  "05667d26425fa92619c19206c62eef19dcf48ffaebdf78d9051bbc7d17b4b4ae"
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
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
