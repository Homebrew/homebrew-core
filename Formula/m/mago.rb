class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.61.0/source-code.tar.gz"
  sha256 "5c61ff8e79fec57c5408b3d4a288e51346968460249f165ffa9a0cf7df0a1bb9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "9b1926dba5bb9f25aa8b7df22170949d86294134279e04895cb382bf77a31963"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c212f00d83ff2b5e9942664a4e45c210fe39140d0d675ebb75a0351c81e8ea84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "062ca88daa4be95622d4f2ffaf9cb7b5bd220da58e67136b0b5aad16025ea103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29628a25d5657ec1dc47df094bd5d95871aa7c1b784763e20c28ec240e6af00a"
    sha256 cellar: :any,                 arm64_linux:       "8608b77d5c8182d94bb1935579600fc60d7f82d9840615d5432332cc9ffc86a8"
    sha256 cellar: :any,                 x86_64_linux:      "4482ed0f79352b9ded8489b01a70dcf0afcab5b012198f19b4e37844dd749ba3"
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
