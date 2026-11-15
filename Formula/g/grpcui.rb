class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "664137b2982cad4bc5e8a8e5963fb46fe3686b6aff0f2f925172fd98d2f8a12f"
  license "MIT"
  head "https://github.com/fullstorydev/grpcui.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a69ee03023f21ca7577740f8d714178fba4d044bc3a6d56ba791a3dc2abf04a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a69ee03023f21ca7577740f8d714178fba4d044bc3a6d56ba791a3dc2abf04a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a69ee03023f21ca7577740f8d714178fba4d044bc3a6d56ba791a3dc2abf04a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a69ee03023f21ca7577740f8d714178fba4d044bc3a6d56ba791a3dc2abf04a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4188f7a2e57bd56e9e477b677d5bb891dfa59f82eb66ec8ebb3e791b23e39b4a"
    sha256 cellar: :any,                 x86_64_linux:      "1128dabc3e040828773df9678da963fe573978be05b48d7dfaec8d21f749e48b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
