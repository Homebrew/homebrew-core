class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6870cb8c47897f2a75abaf3e6cbb160989b4e915b86fdcd9322fb17e073ccd81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d0a16a49611498222ac9e02aeb438e17d5017a9faa6f3be31b90bf23661dbf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b58c6c92fb82efdc7dd08d69e338b16a8c41a5be686754de917dab1f9aafe00"
    sha256 cellar: :any_skip_relocation, monterey:       "1ef657ed7ea94c5f0f9847d7ebaa774af6a7fe83d77fb1795712ea76c2d7c1a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b02cfeb6fdc97d2b939427a91f9e5bad739c1a798f7b308d3af9bd1680c6634"
    sha256 cellar: :any_skip_relocation, catalina:       "8a50fe872a9e184992ecf8899ceee79d814596e0375a52eafcffa88b763968bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34690c885abb6907e22ab531e010ed08162c795f77340756c42975555f155d6"
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
