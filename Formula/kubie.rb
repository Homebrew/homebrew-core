class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.11.0.tar.gz"
  sha256 "98415b8c170483b422ce286c75a90362b520c1a37bc947bb407aaf15a52fe94c"
  license "Zlib"

  bottle do
    cellar :any_skip_relocation
    sha256 "a738e587f50a89113c1820f7718a64e050cecbe73f655d0811986d923a2799f7" => :big_sur
    sha256 "bd3da314d0a0afad8c592611173bb00daa89146f04d1fe7b9279da71e054b9ff" => :catalina
    sha256 "c97e1d927a563504a3a1022c15206ae1936ccf37ac727923fcbfa5be989a14f8" => :mojave
    sha256 "d2dd17d1335ecb571ad441db3b57bbb2f36e1f152ed107937ff0b661d092b6a6" => :high_sierra
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
