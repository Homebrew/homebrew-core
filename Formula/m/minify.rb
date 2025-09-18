class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.3.tar.gz"
  sha256 "27cac242fa5efc35079d09ec7fe00cff4e61678b9a433653db09b97fdaaec1e6"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7c8f0ef23f64b15293dd01a9e9f0c8229f337f29928ba4a8121afcaeba65936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c8f0ef23f64b15293dd01a9e9f0c8229f337f29928ba4a8121afcaeba65936"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7c8f0ef23f64b15293dd01a9e9f0c8229f337f29928ba4a8121afcaeba65936"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7c8f0ef23f64b15293dd01a9e9f0c8229f337f29928ba4a8121afcaeba65936"
    sha256 cellar: :any_skip_relocation, sonoma:        "775ec8e535bf6e3675459ca997fde6b06b3d603ea73c139f8e4305f17840297b"
    sha256 cellar: :any_skip_relocation, ventura:       "775ec8e535bf6e3675459ca997fde6b06b3d603ea73c139f8e4305f17840297b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ec9b8b98f822c02ed3ecbda8b9be2abc465d7793cb2a9e9baaf8b1ba0c3d12"
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
