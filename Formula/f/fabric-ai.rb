class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.180.tar.gz"
  sha256 "53ef4e3dba6a9b333bbad87294fe57ceedcbe66abb218e65ef52c296bc131651"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7139244f33cb1e0d8b0b80b364800935c1e46ae6401e0635c8b90c0e908e666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7139244f33cb1e0d8b0b80b364800935c1e46ae6401e0635c8b90c0e908e666"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7139244f33cb1e0d8b0b80b364800935c1e46ae6401e0635c8b90c0e908e666"
    sha256 cellar: :any_skip_relocation, sonoma:        "a99ee98f9d138b8ecd4502c0b38b9157f88906ffcb2afdba0933225802bad4da"
    sha256 cellar: :any_skip_relocation, ventura:       "a99ee98f9d138b8ecd4502c0b38b9157f88906ffcb2afdba0933225802bad4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40dcd2d1d0090fcefe9656c1d880fc946ef07bd06acb0930f787ebd42a4eca23"
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
