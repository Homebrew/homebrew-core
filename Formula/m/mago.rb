class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.9.1/source-code.tar.gz"
  sha256 "42d927b6f518f620c53719d7f0a7fee9e9b52e8039386eb2165d25b0ed81b052"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bfc8f485899febbc449e4822ca21b45fa8d9711ed4f688d11bed990c0d7c123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fc60cd97aeed25fb8749d98e995f6456cba911ed00bcc8ce66f2dec45a198ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f8a7feb70034feb7cf633d0834dbf853269adbd38d04be524f1dbc9b3f37d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "807bb467a126ee1e5520f88861c14156c6c2c4af3211f7988ed12c3bf47e6014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbffc3b5fb8d46037f4704114970358dcb739da5f78ecb52d45773c049361965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4858524fd53e6f990185a0da86bcafa2c562172309ff477869ad8707cabb127"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
