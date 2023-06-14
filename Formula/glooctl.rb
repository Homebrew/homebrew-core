class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.8",
      revision: "ecc87922d5c24ab3c4aafbc1370df8521fee89c2"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a118d58e2164801f94b1a92ee5c0d0dc5db496ef6c910730484f33614bf78293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09ba4c7ce52174e647430b26217c67357cd2d6af6762e046c9b72a9263ca736c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc7fc7e6354960f32a7a7c0fe610a17d647a35727f65038b6802e1acf9d7eaad"
    sha256 cellar: :any_skip_relocation, ventura:        "d8ec1cc04e8beab6ae2478bd2cd5c5015b29c9be0fb27104ac97835599787257"
    sha256 cellar: :any_skip_relocation, monterey:       "469789078e9ca530acd9c280daf8474d1e243040c7ba4bf940f8ed80a1abf016"
    sha256 cellar: :any_skip_relocation, big_sur:        "5057eb92bd83f9dbaaae3249a90a0c93b9464c757a7d0c994af3b2507d3b5aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67ddb4a7941f0d2f26df230e1da919fc3e9d8163318397e6e72b4540c9b3bac3"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
