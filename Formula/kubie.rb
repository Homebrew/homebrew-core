class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.11.1.tar.gz"
  sha256 "5a0e262d6dfadf1dbb48c54af9952718857df947b2df9f69584e474b4ffc2a95"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f50a9651f010faab3936bc9ca4b271074e34f3d078ecc2b4ffba05d1764d244" => :big_sur
    sha256 "c10519807f4a7969fe7a6af46b400832887ec593d5e3f74a5a2f67ae248403cd" => :catalina
    sha256 "0c8e5b9f4dbd5c057d4e1e9497657d1c20774ae9a179baa5b35fb89df3a1a8b7" => :mojave
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
