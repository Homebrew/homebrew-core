class CargoBloat < Formula
  desc "Find out what takes most of the space in your executable"
  homepage "https://github.com/RazrFalcon/cargo-bloat"
  url "https://github.com/RazrFalcon/cargo-bloat/archive/v0.11.1.tar.gz"
  sha256 "4f338c1a7f7ee6bcac150f7856ed1f32cf8d9009cfd513ca6c1aac1e6685c35f"
  license "MIT"
  head "https://github.com/RazrFalcon/cargo-bloat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c53b8b2d79a6849c1d205fb83756a26d05c9474dd1224c60b2514be91c88de4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f62f85a081b59f0bd758eef9d2bab666fa6454b0aacd2cdfd37ddf0739f7de8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ab2d9245352f227b5f223510a0f5808f12f6c7c646cd97762bffc3a9ba1314"
    sha256 cellar: :any_skip_relocation, ventura:        "bc46e671082df2cbd1efe4c960fda46fbd9d8367cf6dc5dc3609f23d8acd688c"
    sha256 cellar: :any_skip_relocation, monterey:       "3805e2d627484ee6d60f6f5e3b67d1e89f9b4813207f406f462a3a3f582d92f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bef4a80020141209f357649f2574808a043c5d8134f7986dd3574cd61d11672f"
    sha256 cellar: :any_skip_relocation, catalina:       "89b74b010c7fa1ecf1593d3f0134e19d29c95d4457f19103cb1d726f76253f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf7b9ad04fb48b20b2c5e000b812bd6910d65d3dd6cc567436f5e9b156a6ca8"
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
