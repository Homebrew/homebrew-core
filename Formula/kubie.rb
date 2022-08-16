class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.18.0.tar.gz"
  sha256 "a9ed4ab1ef3dad8318fe3d3591b2e16310b90a541eb0f146fc94caefb4a3be37"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51ec674190ecd091e108c1d6754a686c12ec9d65fb7a0db7ba00647a578ab40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c710437c80f2fb17bbe768b161bbe5f37ea09be8ebcd646f4c495eebe59c812"
    sha256 cellar: :any_skip_relocation, monterey:       "faac0311cc077165c4dbbeb2341c809bcc1086cdea0cbc07cb303b3de2aba7de"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e79a1dd18bb5b7eed37b5b5264780ec7361c397502740f8b4a8e677ddef00e1"
    sha256 cellar: :any_skip_relocation, catalina:       "fd2a344e8685f0072653164abcab48713ff7157146c9ee77b3ad38ffce29fd26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20275122d5cfc8fdda3f332d4c1324138a7269d66577dfd9c03a3ad3aec8dc2"
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
