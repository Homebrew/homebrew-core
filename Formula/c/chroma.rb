class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "beff1d23ee8343c66f62aa30f1f18da5813018dcdff147f3ac4bdd734a908821"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "18f7a9576f470a8599324829accdfa900a26b73f2bf3dfce9e579f56ae3790dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80254f05c1da39aa6e08632a3a5615ab8fbc2e55377fac876eb1a1f512a5916d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80254f05c1da39aa6e08632a3a5615ab8fbc2e55377fac876eb1a1f512a5916d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80254f05c1da39aa6e08632a3a5615ab8fbc2e55377fac876eb1a1f512a5916d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cea7131a26e52d213671770734533eb60651f9013f824f409c4298be650cb9e"
    sha256 cellar: :any_skip_relocation, ventura:        "2cea7131a26e52d213671770734533eb60651f9013f824f409c4298be650cb9e"
    sha256 cellar: :any_skip_relocation, monterey:       "239814f474928850034eb3dd571cd398659bd69e618f7e82e2cde85bca23125b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd705c1e6b537ae633275b6e062f04acc786ab8f6db4126a6326f86e2f479b66"
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
