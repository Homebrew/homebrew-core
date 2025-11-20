class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.7.tar.gz"
  sha256 "5f58a0ed1400e2ddd01c99bf30fb675dafe0c6531ed3634533b2d2ded3d3c839"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df68d5615e239c0eda76bb9ff6d7763b7ca8b445e5bc390ffde22b42bbf7435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4df68d5615e239c0eda76bb9ff6d7763b7ca8b445e5bc390ffde22b42bbf7435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df68d5615e239c0eda76bb9ff6d7763b7ca8b445e5bc390ffde22b42bbf7435"
    sha256 cellar: :any_skip_relocation, sonoma:        "69cd3e16cab6818014e715215ed71b80521e6ec8a2a7845bf858a0242c102045"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c3cb8dbeffe8298f0b19a27017b3013e568ed159170e97a86371df483730f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a44b45484be91d58edbef5ba9a928f751d6764f85ae112180cb72029925e4c"
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
