class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.40.2/source-code.tar.gz"
  sha256 "8d274d810e99eb7b397d1549a42800f6efe41da5252478ebac115fcc91028e39"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d435b88226c65aab2e4f5aa6eebae0d52e2e7e968057e0fe1dd3886074372fba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "148c72702e947f7ce9b10fc065ffec8aac863158869f12a207f02ec664a1d38a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e2980c1eeab1081aa0a600775c9ee11df831a5fc0fe4fdc297d4dc3fef5820a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb616aa29da5e10f9099c36c255a1fd7c3d2914f0124afff23c099fa1f8eab2"
    sha256 cellar: :any,                 arm64_linux:   "a3d788faacdf504f62a668c53823acfde158d685f3da5e853e9d32075e9e459e"
    sha256 cellar: :any,                 x86_64_linux:  "d55cf880ea66f77e3ba61ab8960d66492edcc927ad48bebd1192c340c21cd63e"
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
