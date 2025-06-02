class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "a5f45e101221f2770f9ee187661f2f790799c48ff9446e9e8c3bf7d309832b64"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ca25155d3672900e78471d8c3611685a9b2572985a89b8848613fdccfb9bbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ca25155d3672900e78471d8c3611685a9b2572985a89b8848613fdccfb9bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95ca25155d3672900e78471d8c3611685a9b2572985a89b8848613fdccfb9bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "910ca37e8791d28f1947dcc54e626df5af327fede32901cfb972e4e803b20e6d"
    sha256 cellar: :any_skip_relocation, ventura:       "910ca37e8791d28f1947dcc54e626df5af327fede32901cfb972e4e803b20e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b1d05c525ef48e2f1946be68f4e9fbee2d9c2d364d0801f01b29d04d06d10b"
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
