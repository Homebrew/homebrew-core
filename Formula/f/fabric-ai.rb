class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.243.tar.gz"
  sha256 "0758d2366d261ddaa55623d308d9df5bbf2ee29d218ca447207f80a0f3fdd077"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffa0f1829b404db239557e076851c6bfa28bb23a62e525564a5f77f3ff56f900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffa0f1829b404db239557e076851c6bfa28bb23a62e525564a5f77f3ff56f900"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffa0f1829b404db239557e076851c6bfa28bb23a62e525564a5f77f3ff56f900"
    sha256 cellar: :any_skip_relocation, sonoma:        "866d72dd8ffd1bdf2e919ddb066457a7cc47e6ef2ed3c311bb5ad369a9f6e4c1"
    sha256 cellar: :any_skip_relocation, ventura:       "866d72dd8ffd1bdf2e919ddb066457a7cc47e6ef2ed3c311bb5ad369a9f6e4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19425ecd9f13aa114d5325bbd0b83a71009d3cbc6a36761ae0eb308f237455e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
