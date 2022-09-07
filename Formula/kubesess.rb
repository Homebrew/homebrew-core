class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/1.2.6.tar.gz"
  sha256 "a801b5e2b25a613954c948223fade30b5cae1abe7c7df6e9d7294efd86f0db16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f3bf06857d16fdd89716d833dc66b9d9fdd86737e1c38d311ed3f168c987485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e888960712dcf7d95f8a040583f6ea8e8e971cf8cd1df365d74b6ed378dd6f6"
    sha256 cellar: :any_skip_relocation, monterey:       "7b559ef8a7f42db2b93c94467e86c68f81299753f26b8370d69959394c795e9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ddb125f097d54aeb953e541dd2d2d2c3477964b8d1a887a1aa6af0a9428172f"
    sha256 cellar: :any_skip_relocation, catalina:       "33e8f1c5475b097955b49f2d5905debce69adc9338c2f8d1d8b9e8213b570927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d4406e9d6a019fbd6d227c715fa9517ea4cdccd1802dea2b34d5c956279ba9"
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
