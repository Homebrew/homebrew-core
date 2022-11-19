class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.19.1.tar.gz"
  sha256 "b52f0410ba123939c3b3a3b93b24ab42c1dd9308214725650d2f85cfd2f7f088"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ea5bad2c8f2b4b67c933805890bbcb0b8bc67865222f7ad92c812f4bd8c3bd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd07420f0ac297a74d0e76e7cdb7863c53523b31667335c8e769aed6ae1da958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb3ad3e70fe36aaaa745a68692bcd375bce688a3309d65dfa7c32ec8bae2a825"
    sha256 cellar: :any_skip_relocation, ventura:        "4a84ec83cc955c56216784e857d2c50cc5c81ca16dbb2eeeb42f9a6a07d99c09"
    sha256 cellar: :any_skip_relocation, monterey:       "d7f8a6a868b4333ff440881d15d960d1225ae507eb7e47b1ea47bd36929c5b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f35a14d4bd3333ce20a81bdfe4adf1aaea9be0e2d5adab668b8256e23c15835e"
    sha256 cellar: :any_skip_relocation, catalina:       "ce0e93aa80eda7ff518c0a44b015f4cebae48492d83bd43d5181dced1900123b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f386285ccf2df22e623bfa036d1f1fd328a28aa686cc6a3894fba770f39580b"
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
