class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.17.2.tar.gz"
  sha256 "97a6481e1afa1f942be26637a11185d85b3beb834955b642d1769f1777ff39a6"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11b8e41c5688d7fa270259561fb19dd9ac7dab00c5e509057586183a94c3e783"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84e6ba698ef6c8a1b70c12c80de3538249034440f21e1abd0f73e789d79de0ad"
    sha256 cellar: :any_skip_relocation, monterey:       "f84269671f761426e6bad89914c55d279691174ca2937491de44375034195bb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b735b85659e39245e97723d01e0108e70ef649f7432ad4680551ad89df78049"
    sha256 cellar: :any_skip_relocation, catalina:       "2862436438895079e07e1236f15ae1dd6c529997d16d5f707fd9650f87dfe7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b50c35abee2e3785f48f97d9d6713dc19d27b6a932623418e2b1a0daca768127"
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
