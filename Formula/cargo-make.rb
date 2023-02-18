class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.5.tar.gz"
  sha256 "a8113637d6f47c63007e6d45447c39c27e93ede9f31047ccc638a7ba223cd14b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51981f929d924672b96fc1be7ed9ba2243cfca5229d334fc2daad22eb10d2960"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3d226f76d15c051c72fe247146740cbd2bc7fe6c8e6d62c65aec24c94709b7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb0a42822849e445d504fa06f3162a5664975f041d1c6e8e0a0dc12eb196551b"
    sha256 cellar: :any_skip_relocation, ventura:        "6640ce0b0d36997660bf7fe4bbe579cad3655edc9ec3ffa8f3c4d58f0562164b"
    sha256 cellar: :any_skip_relocation, monterey:       "ab1050f052b1b356fa2cefc873b1bc36a9f6e47b1e06b305e8d02ec1ef3fd483"
    sha256 cellar: :any_skip_relocation, big_sur:        "084f666b270ab356c9a88f75b004ac5f4eff51318891a830faef58b9da3b2e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146e38a7fa55d1f6b5869b0949fcf6f183991a2ed088ce2f65969be244860278"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
