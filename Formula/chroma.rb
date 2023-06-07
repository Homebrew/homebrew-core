class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "9d5d1f5ff7f91aff97b9eb7921e3540c863b5f01197b99a1362e777f7b43e215"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87ab6bf60a538f9da75ecda2e11339f8e656531384a298f25c8fd6fa8e8f79fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87ab6bf60a538f9da75ecda2e11339f8e656531384a298f25c8fd6fa8e8f79fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87ab6bf60a538f9da75ecda2e11339f8e656531384a298f25c8fd6fa8e8f79fc"
    sha256 cellar: :any_skip_relocation, ventura:        "9d38a5ca4afecfaa5a4223a06c3b02d5cb7e3b052d873581b612e9e9c395b283"
    sha256 cellar: :any_skip_relocation, monterey:       "9d38a5ca4afecfaa5a4223a06c3b02d5cb7e3b052d873581b612e9e9c395b283"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d38a5ca4afecfaa5a4223a06c3b02d5cb7e3b052d873581b612e9e9c395b283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4fbd9eb2b744eb224b851e3542bcfc7889854bf626305257cc8c0d5c5ff436"
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
