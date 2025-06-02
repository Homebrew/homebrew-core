class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.24.1.tar.gz"
  sha256 "ce5143261e8a798a7195f19f1ffca1c5019537bd78f47e6058e9d4ac4805bb44"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5df72129bfed252ad953f82b5acd977864d9ac59ee45476ddc7b66397da32e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a2fba553cf9bd00b9a8005a28a647f48eeed1d51de1c0c6dcbf57a927e448c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42b8625fd2fc6f375685bf06f1bd7b50ab218d59c15ff65de2572d4ced19ab5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "46a3c9cea92874189808550db28e37eff96f9e85b1989af15a09974e0018fa23"
    sha256 cellar: :any_skip_relocation, ventura:       "ea2ecb8549261ca0ad6cef6e163ac3b3aa22f84900363dc884cb7edcb887d6e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a04c0ef556b6c7623f95fb4ae13254ee40a2d4aebaceaa7a7cd78be27c0a920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0bfc613a538913c42e196a29931556b6895b53bf683f1265741ff64345f1754"
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
