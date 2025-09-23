class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd/"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v3.1.7",
      revision: "511ebd799e64f9af6484feaa84a5e718a77620d5"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dec90e58939504e5de6129a6c2fb49b9b1862a17f7636fb0de6329acb551681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49e2147a5c35cef5da0451124138cb84af9c3d5dd22ce4bbb8a0180f6795b8e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d694c0e72be0e3169087dec8290c0fc1a37a713e902e890eaa9c1952950aa0ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "793b470196d8d3a3a00923226129d26ebd60de42f0d9b5527921fe54fd64078a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e44337608f73f134d598bb9b8a02b234d533bd9483080252f36a2748f6bb3517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba38780a01b3f704fed43e48a4a6df1a99c81663132e200d05b4e74665991c2d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion")
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
