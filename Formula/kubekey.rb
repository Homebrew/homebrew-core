class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v2.3.0",
      revision: "4a25a844c5a0ce2675bb4bd8dd6b55fe11866f7a"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90961ee53287e61683a0d69487e70033bcf70793f615ea3a7700eb65b25aec0c"
    sha256 cellar: :any,                 arm64_monterey: "bb1732d3809d891ec0dc7662b978b983ada2b99d7851abf9773073ae5015125e"
    sha256 cellar: :any,                 arm64_big_sur:  "5bacc10716861d5e64bc4b3cd5ecfe28afef66590dce4988eca12035c3e7380a"
    sha256 cellar: :any,                 monterey:       "89b948e8730c83c9c42208674e3bbe2680ca159f0009a6b64f66d3523b7b77a4"
    sha256 cellar: :any,                 big_sur:        "7f44ae1b135e171a0913b3625106d96c13ad125d02d356585bb5e482ab350924"
    sha256 cellar: :any,                 catalina:       "89590d60b34cda9555c1b702caba26f6af21a19512c34c25ea6d11a1ef7f87ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee788cbbd6cb9e64cd56f74ac117541b0e5769dac5791600646353a56bf76e02"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubesphere/kubekey/version.version=v#{version}
      -X github.com/kubesphere/kubekey/version.gitCommit=#{Utils.git_head}
      -X github.com/kubesphere/kubekey/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "./cmd"

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
