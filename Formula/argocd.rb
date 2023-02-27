class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.3",
      revision: "e05298b9c6ab8610104271fa8491f019fee3c587"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65e89740625461c3bc7f83b3c8576dc8f1ef6a4c8c76fd6b5d7f30ddfdf80646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7afdeb9742fd0288e5ac3aafb266bd1c219ac9f34b671d3ba58937297aec108"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef71bf5de95d3171bfc603f04f95adaa5309fa3ee020a6e3252cdfafcd3aac7c"
    sha256 cellar: :any_skip_relocation, ventura:        "caa7df1752fd12acfadca9951429f5f3cfdfe85efc9de13d9d66d53b7dba3937"
    sha256 cellar: :any_skip_relocation, monterey:       "7422037be7a75428693dd59d9c31891dd19ac03a585230ccd3f5a4450868dc61"
    sha256 cellar: :any_skip_relocation, big_sur:        "49fa7e3a415782c9066c6e3fb5748a28b1e0197c1f7431f32dcfa87a0d39a93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c993d2f34b64664fe41ffaacce1af8d1af379ec750a8f087317934f1e5f0314d"
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

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
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
