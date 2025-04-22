class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.23.0.tar.gz"
  sha256 "b92206a289c9a862593be5ea6b73dcf043279fe115732fe92f25f9cbc2cad628"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e26e375e9bc199c01e433def7971d56d160989f6abf9b3ef10d6066c74ed5626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f668ce417da71a5bb9abb68ac1e81d2ba055661302cbc1c5ea5f14926e1c4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6da15d1ad47314930371de1f2793322e5a50f239598b7d1bb3d767161f99326"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27cad282d60f2a1def1fa43fd6cb8e98d1ad02abc7ef806f414c2eb316de572"
    sha256 cellar: :any_skip_relocation, ventura:       "a3eb15a33bd3c377fa844a9ffdd05e90c7c9ecafac73ce1f3020dd7b9a761536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc337c41ebd864d98210933f082ce568307fd9f9bbf45244bec80a4769c8f2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c66e605bf31dbca5bf9e5a9adac25ee311c4121d4d2839f8fb063260b925df"
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
