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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0653281145ce1f45d3939fe08e145feb444bd7eaf21ffcca71d0d0c51fa7197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "812352f3e583089b7fcb6c4e32c499ae4868544776857e4940eb59becc3770c9"
    sha256 cellar: :any_skip_relocation, monterey:       "1559296b5d8dc338b7c7c07209df54934a935164fdd5b475737e951c4b216ae7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1c2c68855cfaaec0212b95deaa6256699aa93269ef91bac57b648ae85043d7c"
    sha256 cellar: :any_skip_relocation, catalina:       "d235ea9e13512783747226a9a9dda88e7b7a26596f2bf65c346e523187cb3abe"
    sha256 cellar: :any_skip_relocation, mojave:         "63f0adc8c970b289c673096efbfbe15764a48228bb9a60a9ed2d2a2e28c43fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b59881b62b79595df7ac2b3a4a6f3b2de8c215f7909516bc86cfc0bfeed1524"
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
