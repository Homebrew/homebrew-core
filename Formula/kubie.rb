class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.15.0.tar.gz"
  sha256 "8f7c808236a7be745d059cf37b46cc9302479def5a5bb97971de23a9360288ec"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a3f0602cfad49e731ebb290f4f27a96302e37def446d4d39fd9dde8d383b6af"
    sha256 cellar: :any_skip_relocation, big_sur:       "91ce0f837b4c3708deb20857e360cbe503f401c538b94f92a55be9e75ee098ed"
    sha256 cellar: :any_skip_relocation, catalina:      "a61cdc43c17b0811111223983132edbe750df5d9aba421d5542c7b8d789b4714"
    sha256 cellar: :any_skip_relocation, mojave:        "8be9e188196ced121946c3dc1d275611be6e0887daa273eab48a5198fbe2d1ba"
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
