class Dum < Formula
  desc "Npm scripts runner written in Rust"
  homepage "https://github.com/egoist/dum"
  url "https://github.com/egoist/dum/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "fb5aa412a1a034b74cfe0b0b7196ed2fa1e4d0728b3388f52481f9ff7e97547a"
  license "MIT"
  head "https://github.com/egoist/dum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80624adcb9049b506632f0ed70ddccc2eab98781f81a7dec36fd235fa888c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8acfe5dcb35701bd50d2f5cd764248be753fcfa7b04a7b3e640f932ef28d2e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "904e8b9496ff15767a4409e908d15f7786663045d6bca0b827c18fc9f1ae1d45"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f2577516630ba5850bddbbe829560ebabb4733ede3f0957898c7141be2e87f"
    sha256 cellar: :any_skip_relocation, ventura:       "cecd11f66c0bcac5a45cce6757327fb746c7c851a03842743a22c78d66839d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dcdd00cd05691c2662d83d9e0275eaf494656f68311b0a7b45a52ff6b2807e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "hello": "echo 'Hello, dum!'"
        }
      }
    JSON

    output = shell_output("#{bin}/dum run hello")
    assert_match "Hello, dum!", output

    assert_match version.to_s, shell_output("#{bin}/dum --version")
  end
end
