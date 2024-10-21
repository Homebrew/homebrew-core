class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://blog.rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/2.0.1.tar.gz"
  sha256 "a013e1bfaf846ad769f149f19dde6b7656ec52c7d2b10c407c619e4c42c59057"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f159cc145e44a8d89ab483ff2dbd682fef9f012a65f410b6e297539b1a91e2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a47911eb466b293073e7d020db9574935b86723eb50b9be3a2f8593a7ad5cc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb56a0e5a3b701228da24558eea2a652b180a3a2b1e46da960c5c3e5ec37bf86"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f15272e42dba00f32da68d8f2123196f6695883d2ebe66c3cb95aa30995bdb7"
    sha256 cellar: :any_skip_relocation, ventura:       "828b19ce40e2fe4e81007fcd4975f6d881eb91bd49e6d30ec36a13e10126486a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c5b83e3cc3ddcf5fc490a08b40d2d596f815281738661a461887e457863e763"
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
