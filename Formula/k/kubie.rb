class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "f0ad14d393856a71795152a4d0b316f91394d337de073b7f38fa727b745fb66a"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f48231fd355118e12606082571373a47d33286d3f946829b3cb782a32481f26d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317f3e61e30aef45afd22ee9efeec8c6ece39fb8480a9fbf959bc11fcfbc0b08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f541e6a85cdfcdcad8fcfdf7e68d327e8d63e737446bbf865b09104860a13d1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1e79ff01ce8a3a720cc7c68ee96cc969dd5db43cbe00b55ac6bc55e81993e73"
    sha256 cellar: :any_skip_relocation, ventura:        "c37e980c469d899a1cf287ed2005c5ad585fe2d5308bbbc4ae52841a744e41eb"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7ae2a9b2d06ded2cf4660fe76937d66d3361035b2bb5c558aed1dd8689ad8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd83ef170a64af31729511dfd21da02448a0c573e5aec928fe5f400167986207"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    EOS

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
