class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.19.2.tar.gz"
  sha256 "db0843e42dddecdcd3ada373887c5b00dcd6cc4875e67efc0724cf531ac8a237"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "494af191721d85cefca8a84545dde2747c56e5dfff46ef981fcb707c1f39c82c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3986d77f8837acc358d5aac1d0945463b76304a21875d97772f05805b5d9783"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e85a9e37f3a40a2d102035e0083ce18feb3a2798406b6b5b27542adf5be32e5"
    sha256 cellar: :any_skip_relocation, ventura:        "3cad090d78ba6e36571db8068a80a7298659488f536c644b1803bf67db97ae9c"
    sha256 cellar: :any_skip_relocation, monterey:       "074de9ea181f4f530bc382c9c6ee62a5eb7959a4b02624f9c88d9ee306b66f8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8b06a136a1e7391023e50d9ee9f93695e32dece23ca7e22a9776d6f23b6de1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a4ccad9df94c7898f0875f2707861e7a33c6f9ef44004ebdd01dc71f85cf6b4"
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
