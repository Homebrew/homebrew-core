class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.13.1.tar.gz"
  sha256 "5439932790ffcf303fcf0771a5247e730d3aec704b8a68d3335b350fb9c2a301"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6811ed2631e2f19149fdf964bd7f951a759049a6cf93bae4faba8afa49d16f7b"
    sha256 cellar: :any_skip_relocation, catalina: "f1713182409e3bc272e83df099f1154287e285edf10c00db6a83e273fffef540"
    sha256 cellar: :any_skip_relocation, mojave:   "91624aac913d33acfa5377b071d7806a0e7261113782b92e8ca15773ff10a6a7"
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
