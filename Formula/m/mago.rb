class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.27.1/source-code.tar.gz"
  sha256 "4238e957a5911ce0a7e1097652ef3f07d22aed7860448046602f7a0c79c7d209"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fadf2fcb6ea509be23454ae5d6b3aa7019a461524cf824109d125869024a3fc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08cb8d9f0b15475b50cf313a5553d72a127882c8586082672b7aefdc920caf11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4320a22c71d2df9c21b8d5af4888cf5520fc2ff1def7ba2179c86cbb29e02102"
    sha256 cellar: :any_skip_relocation, sonoma:        "0515a1c984698ed7357b17099acce644bca0a2dfdac54b3f32fbaf88d99b6e8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cad02b6405b6da90a161cd1ce293712e58e7d20687aed4fbbbb6597c49a3688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19d65de58c858a0af727798687c519a283d5e42986ae598e8af63f6d905d364"
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
