class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.17.0.tar.gz"
  sha256 "775bebfadcb075abb519ff3a79bee4ef1e1d6a55dbff707a7cf3cd0a54c871c1"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe3385c7cf366063f14acbf5917e93e0eb4fa37db1e7cbb594a61be4c91eac2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20ee24b9cf95637bc3726604e16a6f687fc73b334dc77163a8148552704195a0"
    sha256 cellar: :any_skip_relocation, monterey:       "4bed7baf8ca505c8eb5b4f55bd63c983509ed8dd02d1e3c5c53151606d207224"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ab1e87c3b16d893762aabc44f29be03b8e563a54dae46d47828886a12eb07a1"
    sha256 cellar: :any_skip_relocation, catalina:       "862189725c3ddf2642de56b6dee14ee6cd48c243aba2ca86d6ffadcbd7934ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aac4f42befa57d8ac5824a9f5b1d61be594f49d0c3b6589b93db1df5657cc2a"
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
