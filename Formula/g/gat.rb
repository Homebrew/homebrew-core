class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a57d5ea36b1164d233ac2bbe5d429ef82ea40866b98f5d7193eb0be9fb7060e6"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a1807f36c9d2c3b6cfb10956232998eab2e59d03741b857d38621f4c79ba5d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1807f36c9d2c3b6cfb10956232998eab2e59d03741b857d38621f4c79ba5d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a1807f36c9d2c3b6cfb10956232998eab2e59d03741b857d38621f4c79ba5d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "826c1218df3205fad950d141bb3bfdedd921a2ad4216286474d2d9fc62e3a8ee"
    sha256 cellar: :any_skip_relocation, ventura:       "826c1218df3205fad950d141bb3bfdedd921a2ad4216286474d2d9fc62e3a8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff13f478746df8f5bd39a3d777ec85b11d63a7e79cc87b0f8f528b14d4ffe2de"
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
