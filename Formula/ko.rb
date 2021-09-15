class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.8.3.tar.gz"
  sha256 "f792920cefe6a88e50d4502902c191c813ac3335bc054a212931bf87658ad934"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd1c12f033fd5445442d8559ed596f127e00ec7761cd96df5cc30eed54775e8a"
    sha256 cellar: :any_skip_relocation, big_sur:       "99b5fa11198cf8bc551b709409679446e4503db7335dacc687ecb40c5c5b6931"
    sha256 cellar: :any_skip_relocation, catalina:      "1986d956776b344ac897e7693f83e54c564d2cedd99399823dc4cb3176eff4af"
    sha256 cellar: :any_skip_relocation, mojave:        "2a70df5c9ea436a75d9596d16599135fdcec31d8754e8b2ff1d66255969563dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52a1ea3cdefa10defcd56f7f87d41a27a9d69e32618a28c6a0c554edae5c570"
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
