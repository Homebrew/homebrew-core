class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "f91ffc22ad6416231180197f39a437b7241131d80544ac7df88f56193875e50a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ad4d64310fc1ff594deef77977f5a6dffaaf245ca5fb6a7a2ac8e53f1980da1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e9ef66dba5c8da96dad166a7276ee184332023b98af5c101fae05fa684aaede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820c4ec2f7703e900079004f7629b748d9cb7c83cec421b4dee6ca94687e88c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "45811007d9ffb9ac8fd35495df0717c2b3c4723d05400c25378c2fc52cb74eac"
    sha256 cellar: :any_skip_relocation, ventura:        "7136d7ec284966d88dc07942d208a1112207d3b521f6ea37f7ce583faffae986"
    sha256 cellar: :any_skip_relocation, monterey:       "05ef95c291a651cab571219301cc003dfdae214a49e86499faeb993d1adfc082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e9d5eadb78c68c2fd20d7184609e1a560f8efe3ed6e8b2f144194e8cf3fe9b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
