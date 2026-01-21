class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  # Original homepage `https://blog.sbstp.ca/introducing-kubie` is down.
  homepage "https://sbstp.ca"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "60e5677c8c7efdba94cfeebff9cec3df68bd54e3c0e927ab811fa08f4d519300"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2cec37696426c7c26d87657e9cc983d027a976306801e7e1e5158e98ae2b2e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "072f3833414e64edc0b0a1e9d49df0a9d9c9172ee66ac417823b5f0f46577f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9277355bbf25f470e57bde946c89f266159da93ed7f686aabc783944b76ba5ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d821cb910123136095f94994d9ccf8baff163542e18f01f960830bf51a33e43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b3eaa3da4dcf756b29f51b0a17d640cf894c09ab4a6da59166e6ec1e91f2b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f22560c73cb18b0b7a19c6af3e1eb69220d33cf259994107d5a3e7651bc8c07"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kubie", "generate-completion")
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~YAML
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
    YAML

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
