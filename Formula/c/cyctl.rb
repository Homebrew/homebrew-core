class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0b8b5839b8f62654eeeab20a4b3937129922571079e25bfafc5c323b36e730cc"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2199ca4031ea2acd6ad0cfa040787d26a79cc8eb84fe6f797a7b51914b14d701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2199ca4031ea2acd6ad0cfa040787d26a79cc8eb84fe6f797a7b51914b14d701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2199ca4031ea2acd6ad0cfa040787d26a79cc8eb84fe6f797a7b51914b14d701"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de37e04623e3c6614ea83bdb11b0e6f3905ed70f478beef46ba129981913f79"
    sha256 cellar: :any_skip_relocation, ventura:       "9de37e04623e3c6614ea83bdb11b0e6f3905ed70f478beef46ba129981913f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9fc1aedf164075d7ec36c161a5b362740ce9633ae0309d2cb2441dfbf7bdcf"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cyclops-ui/cycops-cyctl/common.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}/cyctl --version")

    (testpath/".kube/config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    assert_match "Error from server (NotFound)", shell_output("#{bin}/cyctl delete templates deployment.yaml 2>&1")
  end
end
