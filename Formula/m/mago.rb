class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.26.0/source-code.tar.gz"
  sha256 "13f94b5bc9e5ff8c53fce61d23594a6a458a74231409eacca955c5cd86ae2650"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f840defe84ab54f3186c57ee866b36274ede0109a0931ce23c9e4586b25abd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0005bd36bd0eb9479887a18549809a4bf242c0cb5746f95fa550c4bc19bdf427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84748f0e2bac6c7f9513c7ba349edc36ba2819933f66ddc086f7f194cd325c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4fc9821d98e788a5d741d3fc6f9b3584fe3cbb7e8cb4a3ed9efd4c4833070bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aab0835a2ae454da15b08f2871cb7253536de8c05de3acfbd99931c8c5fa42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499e2a5ed691707ad0e9dc8ba10e97cd692e1d6db289963acd69a498e3c58897"
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
