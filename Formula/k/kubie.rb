class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.22.0.tar.gz"
  sha256 "1d3acc24f1e5593ea4ba41dbdffca71a84c3d5dbf66ce5226708fddf2d236378"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b74ccf6957720e1f09ab08238695bc5373c7c2c610836263ecfa1e654ba23240"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9067a4ee4d51c7b39aebeec754c5f4748cb85971393e5dee2ae949e780f8cf4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be396903364247838d000776e4db1828d8af8dafd7ea379b0285fd57574b84ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0797307557cb3ff5b9acad1a1e29b372e2442401a58fef36bfa7f3e12b0ebd3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "75749e75e953950d3b0ec3cbce73ed79255f4e0fc0582f567303e5e262489f60"
    sha256 cellar: :any_skip_relocation, ventura:        "711bf919f6e6a2e2d19fd07840f15ddcd65c141bedfe45273e1eda9b23e9f731"
    sha256 cellar: :any_skip_relocation, monterey:       "8752b5b90e6204c0c0a1e13dd36920ae945618b2ee5a077b13c646f285ae0280"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f7a0dba069b96cf9e9ee9fb6b71acbe1129f56f5b5b7b0e0639fdc52509a750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4c8b324f1a4ede50babb239550b5e934b1330d8fbf74768d9bd13be47016743"
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
