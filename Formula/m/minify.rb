class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "aa66127cd3dbc6cdda731ef7b39533671b0ef346631ddbf33ba6b56eea527088"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    manifest_sha256 "29ebfea556447bedfc7138c18876cccd4386ef79357a517e4f9468b091dd85f0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7225dc0aa1da97d5094630980d732b24351b1e151e239192f714e117d217f33d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7225dc0aa1da97d5094630980d732b24351b1e151e239192f714e117d217f33d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7225dc0aa1da97d5094630980d732b24351b1e151e239192f714e117d217f33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9b897c206ea7242023106fd5ae4955c988783064d3c26b4809fd436ac1cc2a5"
    sha256 cellar: :any,                 x86_64_linux:      "fc3c05df71fd0525c846e78fa47148cc51ce998848895b0646162461b6e4b4ff"
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
