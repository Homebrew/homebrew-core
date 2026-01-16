class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "29e8ed94e986bff7b943c2504a4d283103c4e560c9aceec7df7bda243609e5ba"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cce9bd93868f7d1c95b01b5a576c8cf55ebed260f4d4d97f3c7c1b5b6e6849a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cce9bd93868f7d1c95b01b5a576c8cf55ebed260f4d4d97f3c7c1b5b6e6849a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cce9bd93868f7d1c95b01b5a576c8cf55ebed260f4d4d97f3c7c1b5b6e6849a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aaef8549904f06bd7b2c42b0746f332018eaa9689347def3c48d85744e3c74d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b747d5bd0260067723ada44b0231badd76e4f5ca442ebd20ae580d5f5e04b3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0f4497c7dc699658c832d01d1791bd3eb6790a91907ab7b4a6e928fb82f3e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
