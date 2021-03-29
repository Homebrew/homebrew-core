class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.3.tar.gz"
  sha256 "7a71b843b98d2368b13bef8032d9146b83030be1c15f162763bfd20fe4a6b64d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6e17a99294ed28664ca1b5bdd839d6f44a65f9ef100dcf413afbb15ee9ade78"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b66d7d8070bf25c6750a6eec7869de4e6af74128805f9b7acfa5045a9e51e0a"
    sha256 cellar: :any_skip_relocation, catalina:      "022d3117dbfb8d43b0562481de60f606c0a632b7d934b352cb1732a664152ad2"
    sha256 cellar: :any_skip_relocation, mojave:        "b0e18dc77d67889fcef6134a3e38e9f48eb96682d79427785b1e9cff45139404"
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
