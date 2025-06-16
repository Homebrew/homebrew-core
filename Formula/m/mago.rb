class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.24.5.tar.gz"
  sha256 "b9279e903bc02bcd639e297f7eb81da655ea9cdf3f230bd5687a2bd7fb0342bb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d07cb34f5e2978c48101015cd1573a42dc39778b54f4f76d6857caff730840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30bc06034ed3b6a9761ce314b7b10bebb3941e83fb64d723187902cec3e9d5d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aafb7d69f3580d52bbeecf39ae6fbf7bcdbb28e03d365d6b5a1470e7abd29b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa4fb5d6a28f5f6ee91fcd5af80694af2b69b76d72683ee212e0c866ea53beb"
    sha256 cellar: :any_skip_relocation, ventura:       "e6d69301f18ea4f77535f1d1983d79fae1f03b15bb767bd7e5b2386c7fc4a53f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "177da59fc294fbfe99e81318f266ef2d69a29570f3dc0c1fbc612b2bb389fa7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b2e572e73e8bc54cf6be8d29fc9dab64947d85f978ea5beab3dabc5452f2d2"
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
