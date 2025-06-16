class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/archive/refs/tags/0.24.5.tar.gz"
  sha256 "b9279e903bc02bcd639e297f7eb81da655ea9cdf3f230bd5687a2bd7fb0342bb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5021b8704770f0f7ca4615fbaac12ae6daa24bb46defb25b659b43124ea06433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18f6f9ace7bdff1646fcf120398460c83eac7b5d4f5a2eabba9381a11c74d1b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74b5d515795d8e342c6b0a16f4bedf8c5aadd3a8fdd0180ebfaf01b896ad2e63"
    sha256 cellar: :any_skip_relocation, sonoma:        "63dc1a6d56bc333664ff05609f3dc98b1c1d9f745bb6a84c50e43631c143fbcb"
    sha256 cellar: :any_skip_relocation, ventura:       "cd71ea1db6d50f33799b4dc021fbccc4a3321b0a9bffa2a915cbd4ea1aa2ec8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85950e5e1c0da12ed85e11611c4c9ae2470f5cc52dc0411144b1b8fde2a2130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02c00cf2a503337640f8dde6408dea0ae3c5172f878c3ab5be8888ae5dbd24a"
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
