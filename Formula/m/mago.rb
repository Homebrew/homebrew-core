class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.60.2/source-code.tar.gz"
  sha256 "0e547c4e1880bfedc3380ef9a764b1b817883bfe03080b664ccab826a01b2bab"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0eb0a8f8b297464028de3a7cc7c2d7ed5659008b1878833edf595b233893bd3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8377e34927467b5ba3466df113f00e0b23b4ce0a3009fbb8e07de9af9379435e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7104fff43ace002bb51ed78e6e525227a18c8ee7f4d384fb878f79f0bbdf4877"
    sha256 cellar: :any,                 arm64_linux:       "b4ce1f5248dd915935feff721dc11df8c25c16c0663839de9703c2fc9ccd0c9f"
    sha256 cellar: :any,                 x86_64_linux:      "775e455f3d30d8f39cbddb6132376d91718361b8ba5c09227546b0307b646e9b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
