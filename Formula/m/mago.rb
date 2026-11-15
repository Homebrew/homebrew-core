class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.60.1/source-code.tar.gz"
  sha256 "04d392ab705a4386cc8e9a61c3cd0c164b04edc9f0152cfabc41284edc1f6728"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67341838551233667ce7877cd0047488ee874d9addbb8d3822cbe5a6df09f6bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61a4477f514c2db924c49f6e3dcfbbc0e2251407a002fcc1c7a4c6f93b34ac68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6174565335dfccf9465767101215beaa3b7cbf7ecba393c9cf1db33995e1c50b"
    sha256 cellar: :any,                 arm64_linux:       "af92e05cf66858d198ccb22e480fd7f2e70ef46da7e6368bb619e1821b9f39e8"
    sha256 cellar: :any,                 x86_64_linux:      "6648f7511ffa4f21205c7d1daed976bf356d52d92c6ccd0eb32f7d3d4dd2f98c"
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
