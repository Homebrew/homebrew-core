class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "5425248c199bf506987af0deff9109bbdeecfb723f11b30c712c54a10b78f1a9"
  license "MIT"
  head "https://github.com/benhoyt/goawk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86a2e75f2d3d6d6ee48156bba246b0c8a46dbee8f3e7ed74ad017cebe5f1f7b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86a2e75f2d3d6d6ee48156bba246b0c8a46dbee8f3e7ed74ad017cebe5f1f7b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86a2e75f2d3d6d6ee48156bba246b0c8a46dbee8f3e7ed74ad017cebe5f1f7b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b21ebfd50d30fea14fa1babfefbdb99b7283d8cc7726b8b879ee710b185de85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "48365a54a43506defa109cc1cf5fef6866eb4eecff99ae84eded4afcd7b164ca"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
