class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.15.3/source-code.tar.gz"
  sha256 "978ca96971857ee932543cd0907af3a7e61bcecebafcfe63ac605003d57b6124"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10fc74b681c20174e09efc5bc1267dbea7f2937ede531869593df2e13e679830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80222fe28827c472f2696bbdb3ca441e28018fd3d573dffa359a2255ddae5dc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef3d377a1b3f933c6cb9687357ac6585e3bc71c7274ab99c8cd7a77f30477097"
    sha256 cellar: :any_skip_relocation, sonoma:        "c223d9a4cc68dc9c319b01ad81029505491d86d2586cda3d3c58a25aac3f70f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc98bb0088aa9eb5cd51f907082c742988ed5bdbaf01a5f20fceb27c466cfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f95d5b673e91d4d72114ad1bef2594c3722eb46768fd533beb101e1069da0f4"
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
