class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.8.0.tar.gz"
  sha256 "8ecb73697915b19ae5f3a647d877656ccaaa9f46f6c5f22e81cb8763cc0a8a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca46bb2d470cd7a79ee27becffa3cea1fc27fc0eb48903861a12af433a70e1fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "5fb544f37a38e9eeb9dcb183d202193e96155bf72976c2d1d0182843ee6ff8ef"
    sha256 cellar: :any_skip_relocation, catalina:      "af4bf8d3e835beee35d42538da3cde2fb09e7190cab6fbb64f20bb4499cfbda3"
    sha256 cellar: :any_skip_relocation, mojave:        "a9fc85211b8c64224c0b75687cb4507c17345f6aa45ea56c67a3382d999d1f80"
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
