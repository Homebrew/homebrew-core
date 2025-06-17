class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.207.tar.gz"
  sha256 "1573739c8844957db72d86b4419f600e21805c250169666026bd38087bbda487"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c5ee049124db497a2ed7a431469142ec0814fb8b3e656e130bb9e5df146f808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5ee049124db497a2ed7a431469142ec0814fb8b3e656e130bb9e5df146f808"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c5ee049124db497a2ed7a431469142ec0814fb8b3e656e130bb9e5df146f808"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6f6637712fbd1b5ee83fc4a5388f701c25caf604eaf30cc06eac2ca84af877d"
    sha256 cellar: :any_skip_relocation, ventura:       "b6f6637712fbd1b5ee83fc4a5388f701c25caf604eaf30cc06eac2ca84af877d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7e196518b24c678f723fa33d4303f12a673c169a4527ccacaeae6549075cba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
