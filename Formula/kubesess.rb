class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/1.2.7.tar.gz"
  sha256 "23acb4b718079f151de63cdc0eb9bf70225249b07e411442eddfb18126ae6e48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "404f3224944e025357fbb41129bb2897466e6c53d9d13ba434240676b8b133ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73cdb5893f54f0786e3bec67e8f60db9bb58a7b1dda74fb15254b46ff08cd1a9"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a3dd06fbf4b78b0a837371557b14a905471f7b5e4e6f6250f55c613469396e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aac9da9d676d678a840cd6b98b4ed9fe92bdd65e0bf377095715c31054d7dcc"
    sha256 cellar: :any_skip_relocation, catalina:       "a2581d55b6c93cc190c70f024412aceb526651b2040a6c891501181372310bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0036f6cdc5d2d0f4b4d24489376f9089390c6a1ac7bbecdc843b9411447b2c97"
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
