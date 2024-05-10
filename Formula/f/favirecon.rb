class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a60ef157499003b2f92d8c2b618033496d1220f2c65b96b559760c460236bfea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74ab9774a2f3fcc03056f75474f211e6c45feeb8bdfd38d0f1b8eea66142ac16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1806cc0ba544b008bd0aa1edccfa3f6bbe37646b0d78f77017fb48c0650cc150"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68b22283f43b09f66a9175329d336da13ed69e92652160d81bd19d867179ebde"
    sha256 cellar: :any_skip_relocation, sonoma:         "846b93181d6a46e95c4cf72705b477d600a605e10d986faf0b3ad6782db9c9d6"
    sha256 cellar: :any_skip_relocation, ventura:        "90b5168f2028d55cc9c8af6700390969013759089c98c20b68c3832cbff4ffed"
    sha256 cellar: :any_skip_relocation, monterey:       "a55721d8136f8bbcb64a73acbac0822f2e886f50c6aa8bfa9dc6ce92c6fb35b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d11dac236e4ce644ea731b1c7ae2a76acf24f628ed0eaa03a9175bbebb765c15"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    output = shell_output("#{bin}/favirecon -u https://www.github.com")
    assert_match "[GitHub] https://www.github.com/favicon.ico", output
  end
end
