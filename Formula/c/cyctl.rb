class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "a1532d8770fd8e2dd3bca5195f6605ba66cfe05f322dc6be643826bd5de0ee91"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "758599cd07255e9d3a859bdafe6969a9d020634202a1a4ab9fbcbb0a4b4de851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758599cd07255e9d3a859bdafe6969a9d020634202a1a4ab9fbcbb0a4b4de851"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "758599cd07255e9d3a859bdafe6969a9d020634202a1a4ab9fbcbb0a4b4de851"
    sha256 cellar: :any_skip_relocation, sonoma:        "72885c8d741f10413dcf5877118408178254d7ee2cf06ed95b16afc713c58204"
    sha256 cellar: :any_skip_relocation, ventura:       "72885c8d741f10413dcf5877118408178254d7ee2cf06ed95b16afc713c58204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33f72bedf7765198f6c7c2ba0186b836a18e9ca56d66106fb88691c19e33e060"
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
