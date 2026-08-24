class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.17.tar.gz"
  sha256 "f9abc4dfdf19f5079e81dae1790f7780e5a1cadc694d50007ed38ae7501b41d7"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "976488791bb1eb5056f121c4385ce96f09842bb3fc6315f6620554a747a7d2d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976488791bb1eb5056f121c4385ce96f09842bb3fc6315f6620554a747a7d2d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "976488791bb1eb5056f121c4385ce96f09842bb3fc6315f6620554a747a7d2d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc338607ef381338781c98eb8a0d620fd849f42772364f59d320cb3fa540b01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aea773af393b30e146bae19c99aea0cb6bae4c8dfa21bdfc743c05fbb8bf5d07"
    sha256 cellar: :any,                 x86_64_linux:  "ed1c321d48c3e8f138fc8ea3b80d9ddeb62d97c9e2893f0647b6a43fcecf56ff"
  end

  depends_on "go" => :build

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
