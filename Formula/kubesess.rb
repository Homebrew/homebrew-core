class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/1.2.8.tar.gz"
  sha256 "e6402843c670d7a77e02cde2c89985e6cc1dc97c266161a19b2d906505555e46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe54d6c5a403ded88ec74fce5435a563718a4a9efe2e9b6be0ab9f03f9976ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdc0d53125d359f25ff2abcbddc9b2dadfd5b0e3cac5d04ddf5659287308d740"
    sha256 cellar: :any_skip_relocation, monterey:       "a9c686e355b4424d3a2805b271e07058bbe4df56f1a71917fbed29df938fe9bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "05bcac093b7eb91c4e02a3306098279991756567b60a0354eee09aa880ecd173"
    sha256 cellar: :any_skip_relocation, catalina:       "225b6d010e1bc8c1b796dd0a24ed6a3c30bd359979f145584490e1f959b1fc4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa9b34c9e53fb9dfe9a93d552b7e893d72686e5ae348ecdbb4294eaad144c23"
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
