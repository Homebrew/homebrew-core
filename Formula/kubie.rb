class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.19.3.tar.gz"
  sha256 "d48c012a6a072c88c5df3f590b9923f97eba9f5b123f24ba6810af5ecb6839ff"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68992ab19082a3b4e7ff0d90cdf0032f4caf358dfe26af288ccba44dc3429ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca49b970acddf14ecd3f65dd6cbab4e79d274ea67ddf1c1b2a0a8489ba76e00b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eea2056b209f6eca71330feab7c899e197feada90d6a48423cc6fbc07d3bdb3e"
    sha256 cellar: :any_skip_relocation, ventura:        "f323fbae9c04c96595f2903062e051e67ce837eebbd4ccf2a857533056a324b8"
    sha256 cellar: :any_skip_relocation, monterey:       "16085a0fcdcea0e516e2b4de4d96fbe72a915d93a3caf2d35037769c7dc5faf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "021abcb8fb08f12706c168c318abc355d393e500920559de5d572bf87483b58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28a6786d74ea71df3c0ee0391dc80cec64464a9cbc0132f3a8619310b165c473"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
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

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
