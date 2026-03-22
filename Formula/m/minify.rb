class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://github.com/tdewolff/minify/archive/refs/tags/v2.24.10.tar.gz"
  sha256 "5bb9e99a81f6573b3ab467dd4adbb30d07e609b935398a139f20b183af81195f"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15d61275122c74223a94326de78441da43683dde3597744c8b454dd116339d4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d61275122c74223a94326de78441da43683dde3597744c8b454dd116339d4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d61275122c74223a94326de78441da43683dde3597744c8b454dd116339d4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f09979f7db441b124a34cc87f35faf461a3911cc8d09b8f970c68b02a4ad7f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90e1129a88e52935ff66f98bb5d105ec0a8738af81cc548f7b981538f785799b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d16aade6e627675d81fe352e2161bd904ff578510731542bebc75d3b24a3b39"
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
