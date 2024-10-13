class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "60956fcfcd0cf1d2a75c40621f67ff483010d9aa904b4fe49e7ed7a27eab7e74"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc015e522924a14ff6a237b51e8c3490425badb6185f3e9764e8762e113bca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fc015e522924a14ff6a237b51e8c3490425badb6185f3e9764e8762e113bca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fc015e522924a14ff6a237b51e8c3490425badb6185f3e9764e8762e113bca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3ab3a6a38183581b972bc578d0f1b8a2a215db6323bb1197815c837192860ad"
    sha256 cellar: :any_skip_relocation, ventura:       "a3ab3a6a38183581b972bc578d0f1b8a2a215db6323bb1197815c837192860ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be3f18f053ce8ef90cfca16a254ca828b087fa57bac2d185db8a205b208d23e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
