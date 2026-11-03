class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.25.tar.gz"
  sha256 "900bc080ae8a7da38eb6f78259392479abbf0a0ca8d81addd2230ff6dbbc9520"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff63512aff09d1e2ba944104033ce4cb823457f213d9bb7f3a131fdc03c16185"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff63512aff09d1e2ba944104033ce4cb823457f213d9bb7f3a131fdc03c16185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff63512aff09d1e2ba944104033ce4cb823457f213d9bb7f3a131fdc03c16185"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b810265e4036d6f2ab8044efb6efe0d20131319ea45590705f360e50fbcab98"
    sha256 cellar: :any,                 x86_64_linux:      "9f845eed8fe89b1fc0965039a8aa98a67599fafa4408dc4de391678c0eba4598"
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
