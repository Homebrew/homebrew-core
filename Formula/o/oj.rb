class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "8bb1bf65e024ee5cf54163b7dba391eca4cbf121503cbebc941672fbad718c62"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3087d2ba3af46dd9f6832b465dc3d9807707edf664220825f7175bc301710e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3087d2ba3af46dd9f6832b465dc3d9807707edf664220825f7175bc301710e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3087d2ba3af46dd9f6832b465dc3d9807707edf664220825f7175bc301710e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6097bd7d7dfdd8cf700ea1f553c14b562846980054534194bf6d5bb016dc74ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05a4db6ecbdd79f5f36767a8f8b6f75bbae08ab09236a52a96a6d63a04f67a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28d6024130487fc9ed991c6ea51fdd17b69cb556fb1e532306b43cbaea0b781"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
