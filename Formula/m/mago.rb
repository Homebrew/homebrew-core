class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.5.0.tar.gz"
  sha256 "a784809c333ad6388faf000e065ca0485c6873da69243b145a9cd5b5544b919e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9ff00f9f9ae3139645047b739577c5db706aa25bb45319c01e2e4e63613afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22dfaf6b80332f60350fc6d9a91aff239e5db8ce1f8cf77bfcbf4c5b94b00ca4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "631ebe27030c35033d0d0575440770a4c197a5e20af8c73c7c87ec5a5dee8cc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed85d075a3a319a82ca0287386a0fa4de569cc1e9131fd75c54c582af35aa552"
    sha256 cellar: :any_skip_relocation, ventura:       "1a5e23190f5c1b5866cf31695d1c63bd50c8d36a39568cd6b5c1d08da0b01dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9037a022e244bb9c3c6e99d1ff10fcb3dba875e24c44a926d823a1b2c2921a2"
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
