class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://blog.rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/2.0.3-1.tar.gz"
  sha256 "a5cfbf0637968124d9655109a44222de49b97a882831b56ccf3f11360872dfcd"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ff23bbfbe3dff533afe5971a0dde31a8768848402a4c796697c551a7aa18ba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344f52b08299ed4b08e8af8ae17d5d75ab56cd8c8f2bb017ded8ef2de861eb44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da56f2c3569d78ebba5c172eed393c45c528a6dd08562317496b152ba114481"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "789022cb8bd1473a7fde65f34f13cff32fda018872b98dc2e399a90de058cb3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8e0d2cad2d5ca85325a13a99672b71cf4fae01e677a8e9b55036c4e050614a8"
    sha256 cellar: :any_skip_relocation, ventura:       "0430737333abb2ec5cba2abb5c222dbb2c2a03a288b47dce7b6b3f7042b3740d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b048c156580c152238c72864e731433a1efd29372470df0f78b0fadc26ac6b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3837dc2f129ab4793fb7d69dfabc3f1830b085991b7cf8faabf04b04f5d6e443"
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
