class Gat < Formula
  desc "🐱 cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "dd28462fbc7d668bf357f857aebd0b00ededfb5768cbe13fd1d8dd9fff4cc57e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aad05dd05e92d9fd7782c792f15843646e2cc6561d2f24c01621c33bd832b5b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad05dd05e92d9fd7782c792f15843646e2cc6561d2f24c01621c33bd832b5b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad05dd05e92d9fd7782c792f15843646e2cc6561d2f24c01621c33bd832b5b5"
    sha256 cellar: :any_skip_relocation, ventura:        "02da4aee15bca29a8e3da32cd8c88359700f6555ed0e7371be2c6c54c48712d5"
    sha256 cellar: :any_skip_relocation, monterey:       "02da4aee15bca29a8e3da32cd8c88359700f6555ed0e7371be2c6c54c48712d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "02da4aee15bca29a8e3da32cd8c88359700f6555ed0e7371be2c6c54c48712d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8017b9a5908ef6ac0f5ac43179795eea228309a388f4cd91b3d31bbaad0a9a0c"
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
