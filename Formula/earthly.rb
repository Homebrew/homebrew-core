class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.27",
      revision: "eab653d7fd99146a1f72df1ddaebd64e90b24046"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d19a7bad86c4f4077a9aabdd658e619e33e8b13048a2ff05340a4339a6a5362a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f1d725c99bd3970ec3a5b3c5a10ebd6b4d65ed46817468b6606448208d88175"
    sha256 cellar: :any_skip_relocation, monterey:       "74517777e906ca910191c89dbcff334e2d069d6fa75e122681b63e0beb27641d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1417e6d1af39112232cd3e764be60e99a13852adfe2e7e03ff22a2321af6e97f"
    sha256 cellar: :any_skip_relocation, catalina:       "bbfa4562562061305a3eb2e2fe31803a97d2bb8deba0fb24d3b6d865d2e036e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb90a080590f164049aef874b746576480d97b4af0a890e23203243e480fee6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/earthly"

    generate_completions_from_executable(bin/"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath/"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}/earthly ls")
    assert_match "+mytesttarget", output
  end
end
