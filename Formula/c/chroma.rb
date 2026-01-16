class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "70c21f9d7858f10bb601f3a12df1d5cf20aac6f5d2be1738e7ab69eae1948ac8"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5d8f149037f6a14370543a6076dff7b3de8dc2c547bde78b2eac421bbde029c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5d8f149037f6a14370543a6076dff7b3de8dc2c547bde78b2eac421bbde029c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5d8f149037f6a14370543a6076dff7b3de8dc2c547bde78b2eac421bbde029c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3576feace91b6a25c766ce3774dba589b2762b29bebcadf344e25e9bb7db5646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c28edee1b84db05fb8e58a81f752f932cf98acbccfe9fb64070440a1ddfaf57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4ea376fed6b7ec307d55e49af9f2533c6c92de7f3fa611341ceac36d4980bf"
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
