class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.22.tar.gz"
  sha256 "c450dabbddc37c2195958260edbcf76c78aa20846368b666a5c28e926f2f1ed6"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85fa6bdc5815658e92ae879fa1ca19b18fedcdfd624f42451f06f8806d92404e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85fa6bdc5815658e92ae879fa1ca19b18fedcdfd624f42451f06f8806d92404e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85fa6bdc5815658e92ae879fa1ca19b18fedcdfd624f42451f06f8806d92404e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49c603c85e16b2af160665b745af15deb4e11e14ee00d171fb29b904fce7c871"
    sha256 cellar: :any,                 x86_64_linux:      "88f5a00f8255f233c64fc5c825af95f2e7bedcb94112032c59c5a78a54610a65"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/minify"
    bash_completion.install "cmd/minify/bash_completion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minify --version")

    (testpath/"test.html").write <<~HTML
      <div>
        <div>test1</div>
        <div>test2</div>
      </div>
    HTML
    assert_equal "<div><div>test1</div><div>test2</div></div>", shell_output("#{bin}/minify test.html")
  end
end
