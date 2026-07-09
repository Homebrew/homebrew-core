class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "e2e1eb04fed4eed0715cc1c5938453d1edbf92b3c097ebec0a05d0903ba15508"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a80aae065ef141057b7f99ee4cc3681e940bb236527a336af7d0768251b6797d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80aae065ef141057b7f99ee4cc3681e940bb236527a336af7d0768251b6797d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80aae065ef141057b7f99ee4cc3681e940bb236527a336af7d0768251b6797d"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f71589fa017a00a42a33082c462eaf5f1877d80c3c90546be90351c29d4375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3242f6189632d5baaa85c5118cb002b0abcaf480747c60882b0b2a96e4b7d2b"
    sha256 cellar: :any,                 x86_64_linux:  "4d6eb8c7f34576bb16b476c8115d1fd6c0a1189c389357e661fc8d43fc1dd75b"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kind", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to connect to the docker API", status_output
  end
end
