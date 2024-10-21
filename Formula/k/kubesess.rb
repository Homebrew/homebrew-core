class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://blog.rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/2.0.1.tar.gz"
  sha256 "a013e1bfaf846ad769f149f19dde6b7656ec52c7d2b10c407c619e4c42c59057"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eddc3334fc5b0fc15cd6c0f31966423bb78af73faa3a34952b172fc67c091e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "058f9533d7ca1b04f15f39e5d1b4bf7cda1f1c80b7312aa4428d991bdc14bc35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fab2ac0acbb58327285b1c968177cd003f1076dca948bc86897aa2888ff860e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fe06e9b0c099593ffa6f90c8e65d96105b7b5ab1a9299adfb5d1eca13ddbb30"
    sha256 cellar: :any_skip_relocation, ventura:       "12ad0f02f1b486f250d34ccacc66169e69579702510f8651c0ada6672731ae62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af68f946a622ef231fbdb89a723461ca278ccce6bdc1c829821ec99cc7c9b24c"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "scripts/sh/completion.sh"
    zsh_function.install "scripts/sh/kubesess.sh"

    %w[kc kn knd kcd].each do |basename|
      fish_completion.install "scripts/fish/completions/#{basename}.fish"
      fish_function.install "scripts/fish/functions/#{basename}.fish"
    end
  end

  test do
    (testpath/".kube/config").write <<~EOS
      kind: Config
      apiVersion: v1
      current-context: docker-desktop
      preferences: {}
      clusters:
      - cluster:
          server: https://kubernetes.docker.internal:6443
        name: docker-desktop
      contexts:
      - context:
          namespace: monitoring
          cluster: docker-desktop
          user: docker-desktop
        name: docker-desktop
      users:
      - user:
        name: docker-desktop
    EOS

    output = shell_output("#{bin}/kubesess -v docker-desktop context 2>&1")
    assert_match "docker-desktop", output
  end
end
