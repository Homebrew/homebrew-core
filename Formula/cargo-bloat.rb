class CargoBloat < Formula
  desc "Find out what takes most of the space in your executable"
  homepage "https://github.com/RazrFalcon/cargo-bloat"
  url "https://github.com/RazrFalcon/cargo-bloat/archive/v0.11.0.tar.gz"
  sha256 "16be80bb0486cb0a2fd9164402b2d7449b07c18738a6259d42035c738d3b4a32"
  license "MIT"
  head "https://github.com/RazrFalcon/cargo-bloat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4777c6ebc85c917263730680828d31e04734cd22b9acfe82fb78133fbc068b6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c484c31a20c57b2bcdd1b9dd07db8e89d2c07cfd8ef73d93bc43a4f839567bbb"
    sha256 cellar: :any_skip_relocation, monterey:       "ac5f4b72e63969f885b352c6b55cc08416f77236ece5e680411614b13659382b"
    sha256 cellar: :any_skip_relocation, big_sur:        "205cc2dcf4748b7359e30a48421c27a119413b5d4a49ec9951870c9f631c6542"
    sha256 cellar: :any_skip_relocation, catalina:       "5228867f4e6592b0a4e6adfc0db49caa1bdf0b87aa8067002ab102c61dbbd2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5df002d5d7933e04889d8f7c345db79d7b6f4c583c96fdb4013325eb9b5559f3"
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
