class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.16.0.tar.gz"
  sha256 "0c43848d201ee36c11ddb082a9d16604435c6190ac72f293e9f8f1ce62d20fa6"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a6f6e13201dc9ee630f54d52b8d772b12705885767d089045a72d6e8e92b54e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1259b162a2c4930cf2cb0258d3c02e1fe90129fb3182aee0d4426c1454bb911b"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c738567c18ccdfc3e8eda828b009d6963d527f26eea989b59af0b967403fde"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0c6503d6d2d4d0eb121b3a403cf319dcd30055bb5f6115363a66aedb3be3f45"
    sha256 cellar: :any_skip_relocation, catalina:       "0be56bbdb904d8fc269a90cc78b47eade6db07a39e2bbb59eec379258a6a9f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d58082f93c6d6a680cf537086165e0d2b9a5512c8d8511fb9021b457dda7cb7f"
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
