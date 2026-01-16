class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.1.0.crate"
  sha256 "5a4f82d424823a0036114b6db110447c09858e2a5521bb0c04812d15463b6f3f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00d81d3c5fdafb6398d5156e4b2d1f8d79e890ea77d589efa0552fbf97d32fca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e38d649b6e50c572d125674721575358186b38e51ba1e8c88db214e073bf308d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fa15b3ae47b5d2eaf4a8d850d54010b86990c8b588e1786443cf26d580e9602"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c963e406551cc7e4f2cbb3ea586ba28b778b769d72af276cf4e82b22ef457ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b8dcdadecc477c03c4e6bcec5b83fd90452687ca16448ed7bbb759442a1a25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda86d40a6dfed45f6347dc2dad6ce3fd725386cb3643c4518de5e9aa0a8da74"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
