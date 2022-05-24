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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53d190ca715f75e49c9263e321affe72e8bd6af5519eb63fd9619dd97a230811"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b259fbad773ba552bd0a89165085bdb63cd3fce450760aebccf9e5aa9636608"
    sha256 cellar: :any_skip_relocation, monterey:       "d9a4abcc8ac31fbffb012211975ef64ffd8c022afc916899c1ee9788b12bf99f"
    sha256 cellar: :any_skip_relocation, big_sur:        "03762ab9517cc8ce3b7711608eefa92443dfd7f59f0ead356c78130fa5b6d1a9"
    sha256 cellar: :any_skip_relocation, catalina:       "5b1745bd373e76bbc6098aadc55c20e5da118e14bcd8f7f33fc8a80cbfbd0bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ac2a0fee8f007c3c5bdf5ffbec01c22264b6843ac87bc0b840489ea0f2840d"
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
