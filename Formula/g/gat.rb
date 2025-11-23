class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "04fb6973d67557b1f47a2b9c3c44c41ec16f281809172862e4706a1f59d5cf76"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d214c87158a68a8b482d2ef1ee53b34af557b9b1323bb28475aa6ae95ac0d4c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d214c87158a68a8b482d2ef1ee53b34af557b9b1323bb28475aa6ae95ac0d4c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d214c87158a68a8b482d2ef1ee53b34af557b9b1323bb28475aa6ae95ac0d4c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b149f0b65cf26db3cdcd6e3dd232cd8321821b458491592f22d66d3947719826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac923bda6e0afc23e602bc7451ae715c1571c2fe3c7a14f5261101e874dae93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2238e8d8b010153039952e2f915b4b2594d51b7ff6cdc0dcbe55c7790b1f7d0"
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
