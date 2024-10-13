class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "027594a517e04195696d939e026fc10c6fc85616083f7165818f4289a95e5536"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf71a5398d069b1f447b4530b57a469f92118abc8fe2a2a6313b29dfba387d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf71a5398d069b1f447b4530b57a469f92118abc8fe2a2a6313b29dfba387d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cf71a5398d069b1f447b4530b57a469f92118abc8fe2a2a6313b29dfba387d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "64d92e2a483ded0e1be08de889d20e0154806ab4ca68e91b7ad849abfec59720"
    sha256 cellar: :any_skip_relocation, ventura:       "64d92e2a483ded0e1be08de889d20e0154806ab4ca68e91b7ad849abfec59720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2a6f521be71ac67288b24c5e4ca8940600d549db69b9d5d6158dd1471c77bee"
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
