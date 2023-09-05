class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/1.2.9.tar.gz"
  sha256 "6166ef97bbe9603f0f5561cf478603a2fce4a1e9c9746ee95f8a786836370e7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b58c917ad8fb92a41e2c83a686453197582922dda36fc333f93ed238e406699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fd61e9305b41abd121efb51dc9698fc2aee8f04256baa1f9cdc477f9c1f44bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c78d796a83ec18fe4afeee69f662f121426d2391a7c4c3a9e6278c0f157e3ef"
    sha256 cellar: :any_skip_relocation, ventura:        "84934e248c8474c0883541f5aa5364f1189d45c90a06c342e1791ec984b80a05"
    sha256 cellar: :any_skip_relocation, monterey:       "4aace9938091021492aab7789636e359c665cd9dd89f4af8156f5472266cfb3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6d1196a7512ceee8700b9fca138bc80e3006f522b9954532c8b4d33016786bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d93a752f6abe5044b9a70c94d19ca8ff00d9e77f13be2a5c55ac8e47cf429a"
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
