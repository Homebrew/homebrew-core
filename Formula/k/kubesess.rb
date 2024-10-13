class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/1.2.11.tar.gz"
  sha256 "2f2112a984b1c176cff17070b4bf79a4b9b01fa30551bfc1b6a7b2224a5baacb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "858cce58281a3f15f613adedd45f3a9b4e31ac003dc00755730b3d8462de2228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b65646e6b6830f53f60f2b7ba38aba5d34025872192e822da02664a9d637d179"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d16dc4dcad0df7eb422f6deca08785214e3e14a0fecd6655ad7379bedb916f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76f55efe0d3882ea70d9ca470884d78af2f9090169c06348913264be1c9b572b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9b0ed8cbc35dd6b81a39122dce9f2cdd5456463e33049383c64ca4102079155"
    sha256 cellar: :any_skip_relocation, ventura:        "0311c706a29c0c8f4d12b2a31767449f15afe9d40e4b70a4de6d41a7c0a9cb26"
    sha256 cellar: :any_skip_relocation, monterey:       "642eb485b50dd9bab9d723b7c28e1493ffcd3be2d853c518110ce043caa3b4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f00a52baa80cb6fb70ec9d41d2e6aeac573688a3991286d64c51f399e824da67"
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
