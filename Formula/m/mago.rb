class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.22.2.tar.gz"
  sha256 "5a9b56c0b4268f447b19230b6cd78aaaf684d5dd666611c087058c28f32cd355"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ecb29552c1a4fcab85ff90b5bab0e6c71b25f5eb7dc4c31ee68c9a74c974c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a25793f1c32814db7de80fb6427dc4ffa0fd915eb90797d769e280feaa38c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61700c342d18769c8adcefdd5ae7fe37cc85b95bc1b7cb4d2fbc00e51eed61cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "82714765b8593f6abc5f2a53edc865bc4cbdbbe3d6ff5e1f1ea2b98443a2b2ea"
    sha256 cellar: :any_skip_relocation, ventura:       "52cb72bf69a7be1ceaa5016e26f69990f37fceb000f5f8d0b864abe307dae812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb8d294af6fd9bc8ad8a876bcc2e5706586ed6e419c98d5ae565533ecf538d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6d4992165e7f518936173a0758370b8676f77ca35ecdbf5f33fd7715ec68d9"
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
