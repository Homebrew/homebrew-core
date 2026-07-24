class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "1e6f74b3e00bb652f533331a15e4e0b9d6139a0db6f3f0f1e5b348ce547f72d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c870458af4aea7b7db88a67dd6b86914719ed9b75d3add77204cf3df27305166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c870458af4aea7b7db88a67dd6b86914719ed9b75d3add77204cf3df27305166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c870458af4aea7b7db88a67dd6b86914719ed9b75d3add77204cf3df27305166"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ee95a62644994f36c796a008b24fe8866e0a76fa1a8433b2619cab13ca25479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f056d9350e648de235c029f0a5091ba74e5c6998827dddd2d6044516ed3228b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92bd09a88bd4196b9d220f08d790aa136d8322d1aa776a6671eaa54250a11dfa"
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
