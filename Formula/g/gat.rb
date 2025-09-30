class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "82f31ed14ce1955d8913ec1c7633b2bd8055c28992cf40eff72f816fe87fa47d"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "890039206893da6d4b8a2f2bcd7f92b5527513c176d5e6a8d67e3f52e79d7b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100f71b5b6caaf75ca2c5a5a678b0523eef2a7a07da6d3a40884bc71013c7ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "100f71b5b6caaf75ca2c5a5a678b0523eef2a7a07da6d3a40884bc71013c7ecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "100f71b5b6caaf75ca2c5a5a678b0523eef2a7a07da6d3a40884bc71013c7ecb"
    sha256 cellar: :any_skip_relocation, sonoma:        "55e2dcafcb9ae9bd7ef0ae13579f574387b3226307a764fe84ddf222a0c04457"
    sha256 cellar: :any_skip_relocation, ventura:       "55e2dcafcb9ae9bd7ef0ae13579f574387b3226307a764fe84ddf222a0c04457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3fadc9ee478a037d20b15360f133e13eb2a2886190262f421eb9d39b254e99"
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
