class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "a12d6edc6cd6b1014ad3ad8510039b5917025475395e3788f2bf71f0ecfbf677"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08df5b05cefd307d2f80ec94474ef8d3ea9c62ee172ac51fbf5c9f7538e01ce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13084c205de70ebe1b9e5f1a8b0378d93bd1cf7c9282900c9c8a5183145e5114"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b1bf29e5bf45126feafb45044914284a244212e00e09d48234308f406b37bd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7139c3bda35916d58b4ca21c69884648c36e7dbc6aa00a7e16ae23bbd240e621"
    sha256 cellar: :any_skip_relocation, ventura:        "b92d2a27fb1fa3f362eed35006a05920be368858e9cf6dd6d85631af021918d0"
    sha256 cellar: :any_skip_relocation, monterey:       "59becaa693b3d1d86380da3a53ec578832c65292b19d9f15dd1c37e6f2791395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3adfcd0314a0b4b15bf619705bcf217bdc573633c630f9ecf21163f60d94405b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
