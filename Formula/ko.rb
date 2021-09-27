class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.9.2.tar.gz"
  sha256 "d27ebf3c484dbc320810fff6024b1e759141512e9367a1f5a216dd787fb47f49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4766542a8540a0503a549801001bab2c54ec5197a8d6bd892489f539430676d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "3184b05e7e0354511ba19895c44fca92989ab959e18cb732bdef215774f4a7f7"
    sha256 cellar: :any_skip_relocation, catalina:      "94226d5f7d74f601dceedd51e2760ad9c9ebb3f5ec4e230b7f2e959f130d0d43"
    sha256 cellar: :any_skip_relocation, mojave:        "fbcc6a38e770b3f2feaaa4d5c12099bf61b65bf174d23c0af44dbc9e10c6280d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b84b20432f6629fc46ee56117e6dc087f3269948d53f2d46d57cc57f92a81d2f"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}"
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output

    ENV["KO_DOCKER_REPO"] = "ko.local"
    output = shell_output("#{bin}/ko run github.com/mattmoor/examples/http/cmd/helloworld 2>&1", 1)
    assert_match "failed to publish images", output
  end
end
