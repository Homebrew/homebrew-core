class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.8.1.tar.gz"
  sha256 "4efa5da826d5a944b4a9f1a1b0e92dfe67602cc92099cc5c3ffa8cd01da20c90"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c55bbcd8c02fd66084a51b053dcb3cabaf48765989e0b5dac70af0d82429b76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ea7d1d9802288996fc395fc5d688b13d77a9efbcb66b7ab900835e24f4cd28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18aca80201ab7f3e5857eac4f43d60662d7fd9c055f42f13ae9056d38b664837"
    sha256 cellar: :any_skip_relocation, sonoma:        "64de20d694b9623c1161addb9775b773e7a3450c5d5f55f264d774f12214f3c4"
    sha256 cellar: :any_skip_relocation, ventura:       "3457bad88cbff03276917464c1ab0af09fafd08301039449833e54f70f14ac56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40a8292e1746bcf27f662229d266f60eb44e366107a02e56b6a43d7e363d0dd"
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
