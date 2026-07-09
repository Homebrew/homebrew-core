class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.43.0/source-code.tar.gz"
  sha256 "9d1222c526e8894826f5c36f5adbc1bff2a96b41541d9cdc96cf08b904c681cc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7a70ce61635683f4f655701f78b51894ebffd13dc68258972fa32ab52e19736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b146eacbdabc58bb21a165674f2301d8d561379e4c5cbd6d5f2a599b8a62e441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d794838d077ea5bf584e4cabfad8de1e5f9e888998078c5d6dd737dbee8533d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d124e9b954f1e6696c5bc80fe61414f0bee8c63f30c85e3b73487420786b432f"
    sha256 cellar: :any,                 arm64_linux:   "86e2028cb714bc4e505f3ebd3023429750a16765abe837008150a5c6f59d718a"
    sha256 cellar: :any,                 x86_64_linux:  "98b81bad65cb4ab1e3167af3974340f48546ebefab141627ccb5dff71f726d1d"
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
