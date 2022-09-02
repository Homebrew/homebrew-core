class Kubesess < Formula
  desc "Manage multiple kubernetes cluster at the same time"
  homepage "https://rentarami.se/posts/2022-08-05-kube-context-2/"
  url "https://github.com/Ramilito/kubesess/archive/refs/tags/1.2.5.tar.gz"
  sha256 "1ce69422fc29bde69ac02a209eb7b27a447598c39a3870759aa4c83e553b2e52"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72c05d171ea280936f7ed0db94f6293cbb236e4a3015911cae919a9e9ae8cd03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43a879b312bc2820bb02bd65693175cfa9c9e55e654a365a9213c28640358df7"
    sha256 cellar: :any_skip_relocation, monterey:       "ac7ee0e73a66c4b051746e2571ff34e306b061fab25e82528e9d1af2e766e034"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f17640dae42fb904f21b8154e57e992967cc9236dab47edefaead898c2174c8"
    sha256 cellar: :any_skip_relocation, catalina:       "afd5ee333993a60834fab143fc91e4915d149d4c4acc95a3af190668f70f8511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3f03546e31735708e2ecec345251a0bd3411550baff0df3fc4c3852bbf64a1"
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
