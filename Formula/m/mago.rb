class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.24.0/source-code.tar.gz"
  sha256 "1a9df7b38ebf06b9d2c891ba355ded5febd86fc0cbf64b41f949637895212dbd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9141d8eeadf8143b2988e55f9769d4f158f6a2803968c334ff10ce6a29618e30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db0560781d6b15d410822d8c7850e32488877acad8a80b5ae183c7e825c0847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0186a95864602ee7e9bee55ad21163219ae951059bada829f58dadd5cde0912"
    sha256 cellar: :any_skip_relocation, sonoma:        "8543ffd2bea71316d3de3d41cd3f7268550f6c09c144e67d69d548660eaf5779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1189ccaa85c06c9d22ae7750b173cdd9eceda97dab1711c971bad6767414853d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a69242adeea581d2cae3c92e6a877c16d012d7f1057ea0609b10c4334c6fdef"
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
