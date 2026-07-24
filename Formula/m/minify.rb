class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.14.tar.gz"
  sha256 "bb5b9bdf52ccd19a1d5e69f867fabf7355ae124ba114e933b72a88a8cea20d90"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "384bccbbbad53a46e8464ef11557a2a97d13a31c6b78a3b9e3392a16057a152c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384bccbbbad53a46e8464ef11557a2a97d13a31c6b78a3b9e3392a16057a152c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "384bccbbbad53a46e8464ef11557a2a97d13a31c6b78a3b9e3392a16057a152c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcf9270c4b1bc2b8e287ef30a99a4885fcb352268106df6314d871b70a0f3f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d6647de245e7646244ed56964788cc7a60db1de4e3465c7c09efaadc2b08a8a"
    sha256 cellar: :any,                 x86_64_linux:  "dfa294bbc01542ff17ea531223f9401f31c317bc2020b3c9c5476a7f6c94338c"
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
