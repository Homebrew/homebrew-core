class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.15.1.tar.gz"
  sha256 "456334ae771492e9118bc4d0051978990dad4a75442b12df72574e35c325ca8d"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4df64e815e90f9132934f4678e54f001e7539843c26f2b7a7a7b30244cea444"
    sha256 cellar: :any_skip_relocation, big_sur:       "993809ecc0e1759c1df84d5e1c535b5fb8bb857dd16de933e122d59820734b72"
    sha256 cellar: :any_skip_relocation, catalina:      "7ae832329111b028405c235e41f961ea1e0b749ab4be47cf8c9520f2feda46a4"
    sha256 cellar: :any_skip_relocation, mojave:        "6063f420f052f460de506082bfe6d60ad9695877839c8f48c7ba17226907673d"
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
