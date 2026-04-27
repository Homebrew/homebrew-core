class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.13.tar.gz"
  sha256 "d81dc3e0793d9a69e24d3655f60cf19be8c5cb62f86f6c3a3a4e7b678bc9b31c"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91f5d949d5f1657fc5d0069e2c7230c5130839c6cc78086c66b53b4c137e0373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f5d949d5f1657fc5d0069e2c7230c5130839c6cc78086c66b53b4c137e0373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f5d949d5f1657fc5d0069e2c7230c5130839c6cc78086c66b53b4c137e0373"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c790132610f021f784a48963f15a2400595e6e350bd34bb39f3e299b748baf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a31237df21a69ea40b34f01dd7e5e47471bf32b87898b790a5f9347f40a878c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21baa5fbea3a4819ea59d91d1e54e2c73c0344dea7c2257f230cdbe63e6da7a6"
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
