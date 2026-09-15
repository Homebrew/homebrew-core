class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "c8600ad8634aae2166f09af224ac7c257c8ee403acd42d72f6f1276e786a70e8"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82d113e4c6cc88af46c2922fa18667fe6e5c2c0472b9e237afb32a92be48dc67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82d113e4c6cc88af46c2922fa18667fe6e5c2c0472b9e237afb32a92be48dc67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82d113e4c6cc88af46c2922fa18667fe6e5c2c0472b9e237afb32a92be48dc67"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7aa54468605b100f364aaadd6e6ff66b704f4895fb95a2ac8b737bd6cccc674e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e207f00b56e1857d48d80ae680db6d6b2b1958fc10749de1b61bbc589d008155"
  end

  # TODO: unpin go@1.26 when goresym supports go 1.27
  # ref: https://github.com/mandiant/GoReSym/issues/90
  depends_on "go@1.26" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end
