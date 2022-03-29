class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.4",
      revision: "cf3a452ddd6f83945d39d582243b8592ec627ae3"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6377b25d58bf7065cd7e79de8b455484b8c5981843205171a4563411094ff410"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27c93a59c36318a934bcc181974b7cf65b529e534dede5be0f99fec58fc9188a"
    sha256 cellar: :any_skip_relocation, monterey:       "0f5eb6d98f7aaa58cf9bfa24cdbd0a50e3a8cc421724766f7584c9a6d98f315c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9a915d1a56631a95cee415a22111aca166bae0f9fa429a02deddda6c4298f73"
    sha256 cellar: :any_skip_relocation, catalina:       "7c909e183c3a3c6eee3fe6153e48b485d1afa9042324a60c53066d86ab46198d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0205287405da802a2a34c7bb8efdbf3becf6dffbc566dfa367a0ec9332ec08f0"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_head

    cd "kustomize" do
      ldflags = %W[
        -s -w
        -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
        -X sigs.k8s.io/kustomize/api/provenance.gitCommit=#{commit}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    output = Utils.safe_popen_read("#{bin}/kustomize", "completion", "bash")
    (bash_completion/"kustomize").write output

    output = Utils.safe_popen_read("#{bin}/kustomize", "completion", "zsh")
    (zsh_completion/"_kustomize").write output

    output = Utils.safe_popen_read("#{bin}/kustomize", "completion", "fish")
    (fish_completion/"kustomize.fish").write output
  end

  test do
    assert_match "kustomize/v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patchesStrategicMerge:
      - patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end
