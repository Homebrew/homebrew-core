class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "9e434d55d3695af399f0b8a52237f6057503a0b0cba0e1e4c13d8783d0c20f66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3721822e4baaccdfbec7c869ca0f6ec98263e2b6d70764fd9bcf52ff3bd8b125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3721822e4baaccdfbec7c869ca0f6ec98263e2b6d70764fd9bcf52ff3bd8b125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3721822e4baaccdfbec7c869ca0f6ec98263e2b6d70764fd9bcf52ff3bd8b125"
    sha256 cellar: :any_skip_relocation, ventura:        "600540445555277c03abec28e347154849bfe5e7e846790f8a207e2e121c97a7"
    sha256 cellar: :any_skip_relocation, monterey:       "600540445555277c03abec28e347154849bfe5e7e846790f8a207e2e121c97a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "600540445555277c03abec28e347154849bfe5e7e846790f8a207e2e121c97a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca89334acc0769e33f8b96adbf2d91205d0a6aff67524ea7206dd0a0b1cf0aa"
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
