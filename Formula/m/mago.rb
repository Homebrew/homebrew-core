class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.47.3/source-code.tar.gz"
  sha256 "897c8ac2647751ca3a340f695cb56b938623be385b62f284bff3b11aa09af308"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76ae6ebbe27f91ccf23d3defd38484ff63622d432d4fa72c3aee4ed17466d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9e89256b7aa7923689c776ec89908b58a6c42b2936c9f2cc85b5c5146ecb5d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c303ec0b7603f4306e7867b5c34f22b37d94459465284d699e0d8e38e2c3803"
    sha256 cellar: :any_skip_relocation, sonoma:        "06cab13a1bd79971e63cf1484555dbc79b1b672820557080a20b84a72a5fac18"
    sha256 cellar: :any,                 arm64_linux:   "16fc5dee043f404d7f7e40f7584e8f6feb75bfdfc334a6f18f45f145fd6a7c81"
    sha256 cellar: :any,                 x86_64_linux:  "a237dec0f2596707781e270aac384fcc960df64ebf6c00cb97952a2cbcbe7897"
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
