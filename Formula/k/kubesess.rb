class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://blog.rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/2.0.2.tar.gz"
  sha256 "4d6d99260f54e2e87ac4aa37f4222fa7145f5bd509ef0fc7a988ae735804993a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e455007a5adccc4027928ccd9a92475f8992cd786be3932340a501bacd27596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40479a528b79cebfb52eced09e007243002cc3735d5f30109c1ddb62a772dfa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "542c7d20e582540c879ca159fe3eee868a0c7a694c80e6668c5d8b411ebd4a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b48e2594f72403e6cad8951a87964ad789c7dd21eaa64924c12a98cfdad05cc"
    sha256 cellar: :any_skip_relocation, ventura:       "63e1e622317a8f70b427bf78bacd5b8a3e2e638f9122b88df7376b6f91ae5956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e9a6798bb38489834b653d8eab35ead583880806a5b42108d655851629fa253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc80c331a7da145b77617bf3ac27b912baf774af7abfe83b887e0b54ee60b33"
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
    (testpath/".kube/config").write <<~YAML
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
    YAML

    output = shell_output("#{bin}/kubesess -v docker-desktop context 2>&1")
    assert_match "docker-desktop", output
  end
end
