class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.19.0.tar.gz"
  sha256 "d0408a3fab02fd5a43ef6190956b65765f2ebb1b48432f7ed98314ec8b2f7f56"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0b4b1f6b8e9365b2f56d62cf4f6dcd7d9416411b772a100c4844dd1f62d1f60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d039cbff6f96f338939c107e77e65a9c82273c5a203c5ee9c23368fe3d1c849"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb5857d02f48427bc4b80fe80291111402e97268000f028b9db810156252645"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7cdedf0315694fb1e4f10bbae8b5c43e5c3bccf428b7c092ffce6223e95b2e1"
    sha256 cellar: :any_skip_relocation, catalina:       "34cbb7bc9136afc3098d2f3106506e9480e31175464addef9c26dd05bea6a630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3055831482569099d49f48e321644a1110ee94a8f63a1977074dd642923774"
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
