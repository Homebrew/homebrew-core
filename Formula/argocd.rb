class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.6.7",
      revision: "5bcd846fa16e4b19d8f477de7da50ec0aef320e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19f2423191770265bac20d43b3e5f4721aed59fac8b279e6d39300304c6cde8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbaf6d8f2ab398d1292179e40751e59f5dbbb116b7641f1c5c15397e00a77026"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb85562408b04a205ae4acc5bf866eb6e16481af7125f52b532063de0805ca54"
    sha256 cellar: :any_skip_relocation, ventura:        "bca67b174e72d850972bba18858d02fbc4dbc9886f0a0d2a581d1d8eda93da05"
    sha256 cellar: :any_skip_relocation, monterey:       "a6765a6596ca9ba0b7408a8b3b0f6c788c691ee9423c09f6481618fdf1086d56"
    sha256 cellar: :any_skip_relocation, big_sur:        "893b1bb4ded9827ad31936d1f689ab86960bba6160c0c6d5fa9d5491714d6fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a514d464840d6d2d6bca619df1275a1f96992bd331260d5bfdd949cbdf2498bc"
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
