class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "711c784d377f4ab6b6dc018ff2a78ffba4d45dacfa072939b46bfdcc7700bbb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40848021d0f44332dfd9f63076e267314e743e2db1be19a970bdf96d408fcb50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40848021d0f44332dfd9f63076e267314e743e2db1be19a970bdf96d408fcb50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40848021d0f44332dfd9f63076e267314e743e2db1be19a970bdf96d408fcb50"
    sha256 cellar: :any_skip_relocation, sonoma:        "36bc58ea7a26a204d20aa57d2395e6494073e0783d7b0f253675452d8823a584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb5cefc4748cbefa092315250b8dba59724023489a2b04f843b5ea4f628ee4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "537229ae4e52ab5c70ac111db0911991ad7c89a23c09c3cb80656f6e7f005bdb"
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
