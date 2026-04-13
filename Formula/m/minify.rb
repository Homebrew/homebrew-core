class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.12.tar.gz"
  sha256 "ea4317c2d4410a8aa8a726c1dd04b4be035430530e8ff44ecf000b9dc1b9d580"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b0a96d67657a43a1ad389f1494320d1e8f88e56a1d7f84479addbe6b420cbca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b0a96d67657a43a1ad389f1494320d1e8f88e56a1d7f84479addbe6b420cbca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b0a96d67657a43a1ad389f1494320d1e8f88e56a1d7f84479addbe6b420cbca"
    sha256 cellar: :any_skip_relocation, sonoma:        "49be03bf31f53a0ad3dfc9fcb99e3510014e5d630403788b6a8ad6eaaf418fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38bfeaab57ffa9e74eabedb8e31d48e9bf24b135f3021dbb399eae2c5e6883ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b534215cd09d46d275d303bf0a2bec1635682f5bd1c7a299c9b3d1e1cded47ed"
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
