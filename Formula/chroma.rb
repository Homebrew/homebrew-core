class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "15289ce536e734767e06816c6bb33537121c3b70c2ecbc3431afe95942bb0fce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0ddcfe876a675503de2245dcfd0952fe8b7c6b5d9b06d971c1f2e6f18ff6cd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a629d1829d091dfd4002aadbfdb30a351ec1980cc4f0ae109d8a8a5d3d28b91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ba42ded83bdb72a8dd9dd3c2397f09e1b102a6a413967e3e56a0f4c3387085"
    sha256 cellar: :any_skip_relocation, monterey:       "e5aca47bfbdbc47aa92462a0e06776e04760e754723fca81b2d4d2a7d4f89fcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "88cc7535099fda9a4ac8829c2900fd4bd146490a94c5dc87cdcb37170b24fee7"
    sha256 cellar: :any_skip_relocation, catalina:       "fdb6a091ae08a6d1f3d94b42d2d47f485adfdb3f98d6c055be458725433c0479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad64d7d57ba922f239b67b6ecfc37ad6b41281170058142dc85cfa74ed02e52"
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
