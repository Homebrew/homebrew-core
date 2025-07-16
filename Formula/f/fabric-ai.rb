class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.250.tar.gz"
  sha256 "ca77cbf2553830fad4327358eba5145861f02d50c593879c051a6d150af02093"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "890459165f09e0268044310435981f15ca04b353415b83fcc1f43b74c13be621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890459165f09e0268044310435981f15ca04b353415b83fcc1f43b74c13be621"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "890459165f09e0268044310435981f15ca04b353415b83fcc1f43b74c13be621"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1276698e4b0bda90a9f7ed4cdb0626a80ece9daeab12b6249458196ee620772"
    sha256 cellar: :any_skip_relocation, ventura:       "a1276698e4b0bda90a9f7ed4cdb0626a80ece9daeab12b6249458196ee620772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af69d0ac9a3a897ad4567ed35f740d618c3e799a42a2e96af18eec340b93e20"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
