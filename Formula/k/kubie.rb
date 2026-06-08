class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  # Original homepage `https://blog.sbstp.ca/introducing-kubie` is down.
  homepage "https://sbstp.ca"
  url "https://github.com/sbstp/kubie/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "47a373e94a2b0a1d1ab6c2a36dec49774f605ffb19baad3b3b0f613cf1d9c1ab"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f48e54b33fb6aff7eea15eb358b54c7a0eef4f9b3ec307e36a18ec60ef0b3e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd80f2a8010421fa7615df7ccb06cff66f5c399ceb040710c182edf4e99a0063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6b4833ef4a2538ca3212c06c554f934cce97f1006850abd39dc555985594b73"
    sha256 cellar: :any_skip_relocation, sonoma:        "e325e06857109c334d5377bb1437605a5b7a46663a4fbf38ae164146dd4f72a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628af080a6d7ad60420130420a7919a592ac0ab35296651a43fe67f280bfdd57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1052e0f82f6eaab84f2a385f03182e2c074fc012a711f9228bb0e290ac2cec6f"
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
