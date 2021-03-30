class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.14.1.tar.gz"
  sha256 "526b9e90e98bb0348111c2679a4b78b3c73afb514233f02d54194b26530b209a"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "124525ed806a18faf4847b5fd120520047616eae5130d61319d436faa7f0049a"
    sha256 cellar: :any_skip_relocation, big_sur:       "14e044b655c7d45fcaa1217b8a60bb02f07a73ae79ae031ed3e25170b2c4547f"
    sha256 cellar: :any_skip_relocation, catalina:      "6d696e128bc60865c84076b612dbcf63ca15f0549e97277e3e27d2cc7a812ac2"
    sha256 cellar: :any_skip_relocation, mojave:        "090a9a03a0c1947c57f932f586fd177a0e7b092cc09932c6b75dc6e07175fea2"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
  end

  test do
    mkdir_p testpath/".kube"
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

    assert_match "kubie #{version}", shell_output("#{bin}/kubie --version")

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
