class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.9.tar.gz"
  sha256 "8ae92bfbc437af5b36428a07ace85e08351745152c8b2a87309e57b98fd85ec5"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93c9898d611960cbf4904b7cc200fb0095314e5994d302dcb24c013b1181cadf"
    sha256 cellar: :any_skip_relocation, big_sur:       "38c105b8149d4d127df34987cbb64b034e0545108cbf0c188c0866be00671e0a"
    sha256 cellar: :any_skip_relocation, catalina:      "9d687da909afcb42e76f6acf915cbd8b2bd4c577df154f0ed48475f720aa4d3e"
    sha256 cellar: :any_skip_relocation, mojave:        "df62d4b747506270642606a78b2bdc2624a281ca2af1bda6bf02a57d8bff2cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f6c9ed9ddb23eb5b53fd5b7d8cce8a557e550b80ad6bd2134526bacaccf3274"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
