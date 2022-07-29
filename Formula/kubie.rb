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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465deaadc3ad04c088b7b7932cb6c65fa8f557ee453db8e7f45fd473129ec223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae8987cb210d5b4f3c2f67009d43d53b4b7518e69bef415f20e23c6315194089"
    sha256 cellar: :any_skip_relocation, monterey:       "d34240e629ebe363f55c494809a6c656add6ce6c5ef4ef2c236ce2e402da16df"
    sha256 cellar: :any_skip_relocation, big_sur:        "50d5422834212d85eb01122877d24cee3557f5cf8119f2ad0d1ad0e1beb00df9"
    sha256 cellar: :any_skip_relocation, catalina:       "48cd994100fd020c37f5a361fde3277f9c3b0381636381fc9682249d8ee136dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb936b3fb509ecf7d2653141ff9a073f504c284ce667744360a62e3e3ac5f16f"
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
