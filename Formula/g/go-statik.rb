class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "670d14b003fb883efbd68f3e813b1022ce2325a6b4b6d2e9e6445f38db51f902"
  license "Apache-2.0"
  head "https://github.com/rakyll/statik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c672e9f17026de9c38075bf52e483f3bca5ca36fa89817fd2c788d27a94c2df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c672e9f17026de9c38075bf52e483f3bca5ca36fa89817fd2c788d27a94c2df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c672e9f17026de9c38075bf52e483f3bca5ca36fa89817fd2c788d27a94c2df"
    sha256 cellar: :any_skip_relocation, sonoma:        "238448fa19bbee4317fad64a07c5b7b9bbb787ce6f37858a26848c1417fd4a9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e464666d4d3b1baf38cf757d722630dc72eb7ba4448b719dd1126db1cc44c1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92704b1554def26ec750d099562e022e737b4515ead23d640e0bf93a43da897"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"statik", ldflags: "-s -w")
  end

  test do
    font_path = if OS.mac?
      "/Library/Fonts/Arial Unicode.ttf"
    else
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    end
    system bin/"statik", "-src", font_path
    assert_path_exists testpath/"statik/statik.go"
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
