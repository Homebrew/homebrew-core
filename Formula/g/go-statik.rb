class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "cd05f409e63674f29cff0e496bd33eee70229985243cce486107085fab747082"
  license "Apache-2.0"
  head "https://github.com/rakyll/statik.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "14986febcb2099951a64815370fbe4191c20ac36d289ab23546e0ab621a24660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "95aa24d379a2bbd53eef6bcac8f69bb4813aef3d5957ccf022ba5f34ba7e5281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24547268f10325a191888ab87a8e35b17d4d653a9c6ff6e1bbe60e1ad3f7cdf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26f7b3d318ee90136abccb38d929251dd06a2b689191ad9c34a29acde10a4645"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5a13a7d21ea10888bdfb31153624ca587b2b3424ecf8c97f5bfa512aedf898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5960b8ab88990df3e2a3ef0578da24b674d72c620466af263fdad6b479133fe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "634ac2c0d260f52787f8966eb6fab52eb2eb38c50492420bd6a8c2b119b07864"
    sha256 cellar: :any_skip_relocation, ventura:        "ad26269af443084182676494a9d351fd977e0d8d4644f465b22e2f92498fc492"
    sha256 cellar: :any_skip_relocation, monterey:       "bc500cc264e19fa299d10cee767ea23b79750b4e5891359aa465898e1de6590f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f05d7b15227e1bdf7be3876d90135232083ae1789c08d32641777b9291ef8a7"
    sha256 cellar: :any_skip_relocation, catalina:       "d6d3e13adce186f49cf35be7be414baec7cfa02e8d884e0a97ec9f15108f4cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2912f38eebb2a2fca10361daa336b9d8e01ee7cc0063c71d360339966f00b4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8dac98a1bcf9c946d1ec00fcf2249f1796796f1f52f549988b95d96f9e94fc7"
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
