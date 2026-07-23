class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.44.0/source-code.tar.gz"
  sha256 "34ea981a28e4b895504ab4a43ac4eea6756f835c7bc9a446243634432d9e3b56"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcec9aa3957130b3fa8eb96254ba56743efe3bca50a7f9759a5dba693fcff454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1b7e1176d69d9969743350ea3a161cd05a55cb02bedb2c78b5dd40bedc2848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e754a1b450ecdae15bdb2976eafc4d9154135996fd7f19edd4083502ec3565fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "91ce9f717faf8f3326757e191c37351f40540e173fdbdd0e66560e725f306ef6"
    sha256 cellar: :any,                 arm64_linux:   "7c8c23106bd62c98660ed01a9ebc342579e4f71200f7a6882dce1b0bf3075f60"
    sha256 cellar: :any,                 x86_64_linux:  "49446e29257de8c93c85674b35b7572c4b86ce13bb586494dee6fd03288a920a"
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
