class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.26.1.tar.gz"
  sha256 "385956d63bfc8169f5dcc2eced316c2997e9b41962918bd86bb345b43eca5868"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "480ea8872261668e930a327831d47db27f49dca28eb4ba567156d07780db1a65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63a3abbb529f9680e9ba6a042e14150007c09b085c19c97eb8606e9f4a0bbee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f87c201197e099ac2c4dc7d4a5cb7f31e5727f91713b7ef1225ac5573f47813"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea2f1c78ca8a1f5406ba43a00e502277c34ec7b760c0fa3fa86ae15e44e1ca3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3da339c7ee7074e6631010c6d54c7f24e3091801db29e28ed7ddd70660b55ee9"
    sha256 cellar: :any_skip_relocation, ventura:       "2f78b84bf97b078a71ef3f9c60cb3ed2165294873fd6de9c2ca9b78a2f786616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abad642179450c74b209e4d6c519d1b6703e0892968623c95a72d1c65fbb61d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac86894e4d9cde9e39836c5a10532a6f595cbd67c766c5f03ad07a22a114504"
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
