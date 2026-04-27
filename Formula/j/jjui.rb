class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "a62eb917e69368f72100e2793d3781722fc0f66038e79303bb1b12ef0fc8b8e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5890d31a59ec8c100e2972f636da9088f434fe54cc8fcf91673d1a3f68c35728"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5890d31a59ec8c100e2972f636da9088f434fe54cc8fcf91673d1a3f68c35728"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5890d31a59ec8c100e2972f636da9088f434fe54cc8fcf91673d1a3f68c35728"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e6b7c0ab0c1ba6919d80022315e4a4fc84ba7efa938f6a06ca0f7ce38acd602"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84d877d2a8b9de692eb59c51f1d75bc539a49132e4faaf9d48247fdef5503011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e17b5b6bd403f75bb141954b4eb781b985a5573bac8cd37e4025e539083324f"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
