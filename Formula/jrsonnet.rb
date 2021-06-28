class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/CertainLach/jrsonnet"
  url "https://github.com/CertainLach/jrsonnet/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "98c90faeb5ad9ceb73ba9b335ca8bdb5bd1447a23af0de9a2aafc181b2b1876f"
  license "MIT"
  head "https://github.com/CertainLach/jrsonnet.git"

  depends_on "rust" => :build

  def install
    cd "cmds/jrsonnet" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
