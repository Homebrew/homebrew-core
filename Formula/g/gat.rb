class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "14cdf8512c6245733c484389085229d6ade29d24c0cfe8a1578a3123238efd1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4e34bdc0d5a69870adcc7ed9f63f33a981d6413789e9b601b78de8b2a89819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db4e34bdc0d5a69870adcc7ed9f63f33a981d6413789e9b601b78de8b2a89819"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db4e34bdc0d5a69870adcc7ed9f63f33a981d6413789e9b601b78de8b2a89819"
    sha256 cellar: :any_skip_relocation, sonoma:        "8638f3703a893fc06471d1f52b33990a9a7d62e15087bbec6614c6d046926c2c"
    sha256 cellar: :any_skip_relocation, ventura:       "8638f3703a893fc06471d1f52b33990a9a7d62e15087bbec6614c6d046926c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d02b9b2867378ac92e4cded979a71cc6bd3c95d2933f35f63caa0d40444cdf"
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
