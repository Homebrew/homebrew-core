class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.17.0.tar.gz"
  sha256 "c61e84390aab9c38a3eaeeabc1b87f7e21919214996e491e58b50b5e959a8c08"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b94e83a7e9198014618d50c51b77729b20c9c9a49a5d88299a81c4974f1a05a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a151ace313cfeaa97d24816cb35889494201187b1ebd2ff2efb343b57d137568"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "273a45ab7f67f400fb46fdc881eb1f09952a5113a707bbc295865e6808a58fce"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbffd356c303313b624f2b4842a79685e1b6ff865063303ac10375ea37dec9a3"
    sha256 cellar: :any_skip_relocation, ventura:       "b9670cf181db3b2e758e877c860f2d6a221de43ade2589603c61427ef0894490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81152f74a692ac5be99fc6b135847e18bfda21b86600a88ca7bc74e404fff3bd"
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
