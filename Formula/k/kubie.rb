class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  # Original homepage `https://blog.sbstp.ca/introducing-kubie` is down.
  homepage "https://sbstp.ca"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "e39dc338df5c446fac1ca0380404bdeaf5049143eb5bfa597f684f42b13a00cd"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bf373f5a257004e1553d0593e27ea6a28d9b4c34a668325a6d30fe31b528c01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86dd04c9d52d2fdd408e3957ad3a2404815396b701062cd33477544cb44a3a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f21d5468eda77d4b3c5772dbbfcb65665acfa471f1af7585b63cb0b23fc636"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d72c2fc78a91d92e861ffcf39219da0c2547ca0c07e276dfbdb4b3312cadb30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "398f89da440d7630e4e588289404e54929c425cb146e72a6eacb5d6e2cd11039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4960b4f584fa4f77acf08d5e458cc6560692047d629fc689d1d0f8d61d64a5c1"
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
