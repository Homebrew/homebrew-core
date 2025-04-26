class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.184.tar.gz"
  sha256 "dfe9cd6f6bab169e734d3bb963aedbe4a678390b01db5e82b47512c02c8c30e1"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba47c60c5ff17769123364b0159faa77b1ee5dff1af61f8c0947c993a620c74a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba47c60c5ff17769123364b0159faa77b1ee5dff1af61f8c0947c993a620c74a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba47c60c5ff17769123364b0159faa77b1ee5dff1af61f8c0947c993a620c74a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6fbca15ef186767f833987167ae0f14f19df86ec814e005f04512c90ad92631"
    sha256 cellar: :any_skip_relocation, ventura:       "a6fbca15ef186767f833987167ae0f14f19df86ec814e005f04512c90ad92631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aadbf6d53563bf2b282f193f98afae411b52ed7360f87db48b5db950ffe347e"
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
