class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.47.6/source-code.tar.gz"
  sha256 "66da1a17e098d8ad5456c3cf5a71eb69057f88ef972470a905cea68b4c9e1f96"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd62a0b609364a5dc4884c93ef71d2f3ec397c336a41bbc43f05524e8cd4d6f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa831307557f449a44e7faabb7a4edf30432430fd822811ab25123f670b04f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6cd38b0633ffbdbd5ead4788779043cef72d38e38dbf8bf0655fd314a8de29a"
    sha256 cellar: :any,                 arm64_linux:   "8a56cc54bde170e9c419be4055afb033e86be6edbe496e31c7413b31d48285bc"
    sha256 cellar: :any,                 x86_64_linux:  "ead66416b0b9043028ad04dd70a53e9e4b2762c4fc072c783199a7ae8af5e19a"
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
