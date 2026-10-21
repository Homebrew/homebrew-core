class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.58.2/source-code.tar.gz"
  sha256 "1e8dadc60705fd4cced53a186365a19d20d5acb16c456bdf880bb430db4e845d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ea7acbf37d3a8671bf28bc86c0fc9b5834f6182dfe9157d163aab991f80e0ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4dd630e72618a5f5945b6cbd7f97993cfa991d9ac44e1f5d9603278b14aae80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22dc18460888b6f77623c4f5f77fe86fcb6af08b0744898b4bd124fb5380c7f9"
    sha256 cellar: :any,                 arm64_linux:       "db52f8ac326ed92debf76e2d5deaf641e0f8de77417e9b7f42e5bb400cb71c8d"
    sha256 cellar: :any,                 x86_64_linux:      "b38a66f8a88404cf04b1349cb7861f17999a4460928d13581c124ae2bab39b2a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
