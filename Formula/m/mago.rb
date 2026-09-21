class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.50.0/source-code.tar.gz"
  sha256 "343e01f87ee7d598bed37005ed66078b5cde4353a9adfaa62ad943384a58f2c1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "343d3aa16c1c9806c37a982f83571bf315c52e3fd3f7ed5cbd1e076870e96d4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d9cd550319eda66b7b43300599954a6ed5361de537e6152ed888f11bc6c6446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "379e950ad42980a64d51135183409c4e75cbe8c94b4062ceb80527147afaf59b"
    sha256 cellar: :any,                 arm64_linux:       "d0cd536059f72f2999d82d96e5f3ce53a50971e582e3497213c6846db3c87672"
    sha256 cellar: :any,                 x86_64_linux:      "f8f5d643013b303b7a463ed0beecc4ec79e4fe345fc086a858c27626d6854263"
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
