class CargoBloat < Formula
  desc "Find out what takes most of the space in your executable"
  homepage "https://github.com/RazrFalcon/cargo-bloat"
  url "https://github.com/RazrFalcon/cargo-bloat/archive/v0.11.1.tar.gz"
  sha256 "4f338c1a7f7ee6bcac150f7856ed1f32cf8d9009cfd513ca6c1aac1e6685c35f"
  license "MIT"
  head "https://github.com/RazrFalcon/cargo-bloat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ae767141d1028021318b1886ad5b96e2fcc79ff627367a4b0ec2a6d974b9ec0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d20fe302801586a94fa4baf15d975abbffc6de9d4fe40433ceedab2043511f2f"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9e92a49a5a5adbb556967210fb908b4ba49a1dfa31ad4278d043506d16867b"
    sha256 cellar: :any_skip_relocation, big_sur:        "75fd96de719a9759f68abba8f4a8998ab7934412bf02893c0f2ca4329047e7fb"
    sha256 cellar: :any_skip_relocation, catalina:       "45043efdd3e3148e6b8f6c2d62bc79584a0dcbb135183c8f25e24cf4e73dbe9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60829d6ab3e72892b38c1dce8d1656b5a7c4d9160c1f6222173558452e1147b2"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("#{bin}/cargo-bloat --release -n 10 2>&1", 1)
      assert_match "Error: can be run only via `cargo bloat`", output
      output = shell_output("cargo bloat --release -n 10 2>&1")
      assert_match "Analyzing target/release/hello_world", output
    end
  end
end
