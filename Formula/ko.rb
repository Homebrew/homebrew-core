class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.8.1.tar.gz"
  sha256 "8efe36bed8c367603b3b10a1db2b7e57bd01bf9eb9f48532ef6a7c7ba304732a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a1fe53fb9e0887724c7c90a8e10f94bc87cd43eeb703985752f2bb9cf070bd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab51fedb6e7e107d3c7cf11578e994b99a5f4414ba578ef33543046c736726f3"
    sha256 cellar: :any_skip_relocation, catalina:      "fc493090de5972372006e1ac97f0bfe150130fdf1fd03abede777a2638dad0a1"
    sha256 cellar: :any_skip_relocation, mojave:        "40138b8a4416ca6d55ae6ad507d2dc1d7feda8cc4e09a35fa418b39341654b87"
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
