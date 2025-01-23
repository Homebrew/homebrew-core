class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.3.0.tar.gz"
  sha256 "1826a16d286f2107ddee5622f6e7bcab2e1f95cb53ecbbe24bcf4dbae4369c3c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd20e09b2c082dea6b60d1bf0c3cf080b2aa58af62d41347cc7fd50911903c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cdfe7dc988483513d940f4a97c9588dbd9d224998d214088a270775a67c3eb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88cd696ea8bd2f67e1571afda600c49ef490d867393819d506813e7a89cfb7b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4e1c5758aca47100262755a181bf7ee8b74a34c847896f5221e0c81880d9858"
    sha256 cellar: :any_skip_relocation, ventura:       "74e2dbdf76762f545964435ff649efcf2c32dd8ba8f08744f087dd16b1ffd80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da93f5adb32de15b74ea9b4a90117d10a4ba06112a0dd5d6219f9e847b333b78"
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
    output = shell_output("#{bin}/mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';\n", (testpath/"unformatted.php").read
  end
end
