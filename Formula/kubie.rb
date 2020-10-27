class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.10.0.tar.gz"
  sha256 "67f09d8a2101192452c6c37a2e5228d62802618db3df2892afd699feb72b4877"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "955b6ae1436406d41e9ef9ffe6df4ac571d8259becf59b51c71d938367c826a4" => :catalina
    sha256 "3f000617f7175dbc8df85d68b8720863fec9c1f2bae2a49d5d636feb856a3a0c" => :mojave
    sha256 "43e175dfd87c5f3b1dad37d2588b4063d8e1f57c16d11d84ed5d901dd948f94f" => :high_sierra
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
