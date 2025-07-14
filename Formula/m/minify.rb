class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.23.8.tar.gz"
  sha256 "e06cf3d2a878821f9f138d187e652d6ac65c0eefda254573cd484eabc355760f"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd074822109f9ded330a038e7bae7a1b098fc0744ba0b72a78d0aa408f049340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd074822109f9ded330a038e7bae7a1b098fc0744ba0b72a78d0aa408f049340"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd074822109f9ded330a038e7bae7a1b098fc0744ba0b72a78d0aa408f049340"
    sha256 cellar: :any_skip_relocation, sonoma:        "76273a14c6067dc001c03b837547871e36572804666cf4703a3c2a34ee7ac8b1"
    sha256 cellar: :any_skip_relocation, ventura:       "76273a14c6067dc001c03b837547871e36572804666cf4703a3c2a34ee7ac8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "444b36148ee861ac905580a924a737a3b7b262b0bfb7e41601f627bf4d87b1bc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/minify"
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
