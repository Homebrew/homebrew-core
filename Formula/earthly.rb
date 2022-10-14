class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.6.26",
      revision: "4a8d66e3b30d8ee758e7d71b40bc027f92e9adf4"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea8999580ecf923cbb473f76ccd98f530139501fd757f48fc1a251ba81bfbb15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9478bb8baf56e0a696cf8cfab88500cac812b41f14d6826688dd00c2a170a59c"
    sha256 cellar: :any_skip_relocation, monterey:       "f328ba7e9702ba13e3c7d246b5b281e0ab6a4532da1681e913233ef78daeecb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "10453d844559194d9b0969b2b16645da652eb11d5a485d98d7e567c36630effc"
    sha256 cellar: :any_skip_relocation, catalina:       "8853711628422aeb20b81d8d94d67099a258b4e84efffdfc06eefb930d75d149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb8576b1903476277f79deed7999158ba94f8c86976c886e880c802e42a4b863"
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
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
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
