class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.6.1.tar.gz"
  sha256 "2ba540ef1bba114e32967c0b130d9ad555cffe15f7826db2397ded08c9db90f0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90444977c6f71d517ef363bae1ed38be90cee54300d846f033cc5191add06b0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a130ef6b5dfe33783afa8c3cf5477614b2683fd058f1be2048ebab0a345f0d49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "addb231e10ba34789007734a21561b2ee7b9f25d746b2a3b27f24dfe9624eef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "92f1916d3435715fcb72a1840d021985a4dcd8702dc4ab6df2a1ef9ba1b75523"
    sha256 cellar: :any_skip_relocation, ventura:       "26d5be955026f17a08964433fcd91adbf982c9d01070244247f82a4d4773785a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c50b1371de7253e4989697a8206d1913245c75308424688c3cec5a8d994ad0d1"
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
