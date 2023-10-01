class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.28.0.tar.gz"
  sha256 "b82c2dd3d0c41203790258755df1e22b90f6784670ae07ae802e79a8e0fe19d7"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f60aefc0b5eb2fea81838719ffa4fe3cf086a4c019f62e3b318fb994b4d2c377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b473db61044d36bd80a41cf8a7367d0ab4298ec8ecc673a136e361c71163bc98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7637ee1f8b986cef7db9d5e6b673e5b473c0f3e72d3debe008aa3e2e542b4aab"
    sha256 cellar: :any_skip_relocation, ventura:        "df188369e7b3e592731eff394950eb7e7f32394537f6febfa8fa201b73ef5495"
    sha256 cellar: :any_skip_relocation, monterey:       "019b822b7ee93b65bb1d570cf56e3448d051443165355a7dd279fef0db799711"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5b3c03d2632290403c9c9a4fa52dd11e227990e90fb690ec437fe334b0f5720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b131c7d853e091a7ced6efe5ec48bb2089dbac3bf10ac679d6fe5f2dddb23c"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
