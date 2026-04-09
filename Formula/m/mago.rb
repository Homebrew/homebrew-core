class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.19.0/source-code.tar.gz"
  sha256 "1f606b3fb9dfd674519ae8a461cbf4fd01b91537d61a0d4792d7438da2f6c3e1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cf8f948bd2634ee229bc175e6c2603036d83740585d0aaafdeca034ed203503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b978c529eb57cfc198654c8e1865a9f03aa99edb711ebfa2fbe37ed00f21e5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c583da6a84f66c3e90bd54b3e7b345173e8fc8675e5694cb71ace6a2a62c8e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e2872899a87ecd02d4966941e0cc5ee94b5b5c3d337055e0a1c934b2b7d0b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d696c64f75698f2a260b392c23d321832ca1cd3ac9c27b0ab3a62a6ae188783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493999b920483f33f1f299d058e488e5d7a3b9afc7c49f533570d5a03be49001"
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
