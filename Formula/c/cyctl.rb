class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https://cyclops-ui.com/"
  url "https://github.com/cyclops-ui/cyclops/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "83ad0e9db37065452e27991c8af00faba2532f67900f003b6c2a2bd7e896baba"
  license "Apache-2.0"
  head "https://github.com/cyclops-ui/cyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "952bd85443b83b07d5cba403ad36dea3130bee9bcaa9799b9dc7634905911201"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "952bd85443b83b07d5cba403ad36dea3130bee9bcaa9799b9dc7634905911201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "952bd85443b83b07d5cba403ad36dea3130bee9bcaa9799b9dc7634905911201"
    sha256 cellar: :any_skip_relocation, sonoma:         "f21eb0b047b37edbd933a740842e3cee68dd64b716e4f0f61743f464153dbdf3"
    sha256 cellar: :any_skip_relocation, ventura:        "f21eb0b047b37edbd933a740842e3cee68dd64b716e4f0f61743f464153dbdf3"
    sha256 cellar: :any_skip_relocation, monterey:       "f21eb0b047b37edbd933a740842e3cee68dd64b716e4f0f61743f464153dbdf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc84c101ac9548d99654289816e1c08f36a6e9aa6dc59f6adf0bb24bcc54597a"
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
