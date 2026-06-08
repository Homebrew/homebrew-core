class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.26.1.tar.gz"
  sha256 "1bfb1559f6d2e05f5ba3d5285eaeae1c9438e1134531b7a12fc3ddd12ffbb2f5"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a3fd4ca5c699f710cd51f64d3e1251d423484df05da6f2dd41a5cddfef0a589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3fd4ca5c699f710cd51f64d3e1251d423484df05da6f2dd41a5cddfef0a589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3fd4ca5c699f710cd51f64d3e1251d423484df05da6f2dd41a5cddfef0a589"
    sha256 cellar: :any_skip_relocation, sonoma:        "289589c5f2010139487247483ae72a056f52a2fcac977310291e29a8298d06b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b90f3c2f0d3f44f9345107212d83478f13ddfc59224f4e072a819af72f97134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9c88d3aa12afd25cbe7b9c1d4f2479d651fea024401d363553d313332c165a"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
