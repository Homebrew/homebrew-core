class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.11.3.tar.gz"
  sha256 "ca75d483f347632be344ebeca3e8d3c79ab4d9255ae46005f6169b4a06d00baa"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad5c84dc7b76989ccc1357ee4d969ba76e589906a7d337df619645029740dfec"
    sha256 cellar: :any_skip_relocation, big_sur:       "cbeb61de1d6562f209886c58f653c2fed041f67e278f5dc5d8541e8112d2ff94"
    sha256 cellar: :any_skip_relocation, catalina:      "a1fefa9d7c807c22ee67fded137aa41acd89835f0c6eee665494e87ff28ea167"
    sha256 cellar: :any_skip_relocation, mojave:        "ceb53038e9c4e86c48716b4d2dc6865bd85594595a57ef460c606060ad2128d8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
