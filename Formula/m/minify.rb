class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.8.tar.gz"
  sha256 "bd3285a06d96f296129d961ac72c3872bc373f9b32a14039c0fb81bd6abe9cbe"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0138a450a4d2c7474664cae9a152849925050efa33230effd30389181708b0f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0138a450a4d2c7474664cae9a152849925050efa33230effd30389181708b0f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0138a450a4d2c7474664cae9a152849925050efa33230effd30389181708b0f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "64a90bc85b38664a626773471e2a142dcdc62c16e3ad90d93e106b68029be5a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca6ab1c520dd5d13931d0a9c7fe5a90699e4a64775586ba8a7610f1542061535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35074eb8e6224a0481f5ec696c1697def61e1c8d2d8be2575b4c656fde60a803"
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
