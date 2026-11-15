class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.60.1/source-code.tar.gz"
  sha256 "04d392ab705a4386cc8e9a61c3cd0c164b04edc9f0152cfabc41284edc1f6728"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c490f893f06276045f43e7f842fcc47e4cb4844fcec0cf01dcdf72b6450d7ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38c187e0711057ef0aad1af0044dfebacc7325b786c31baff5c467b7f4ee2224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e93ae8150760e2eccc73a3867336206dbe7811f3f7a10744f63f9fea3a05df8"
    sha256 cellar: :any,                 arm64_linux:       "b8ce6f34105684d04d8141338ae8f243033739de8854cdb2692c1ff377673f0a"
    sha256 cellar: :any,                 x86_64_linux:      "c9b4308cd120d62e225cd5a527cb26dd666819ac0ddc0884b36b5731ff6b8dba"
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
