class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v4.5.1",
      revision: "746bd18a8c0ba5768b4519778c82a5fb3e667466"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d53988a2e5ec22509127e85bfc143efd2c2ecd43edd8c877aedd583f901c3c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28a43fef34d582207a123aaff1fa3be6ed39fc019175755e0a9061098ef27583"
    sha256 cellar: :any_skip_relocation, monterey:       "0dda8e638b9bb7fc177f18efa2a04cfcd8d829be0cfe7bbb01169496b31d6a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "51b926b6890cfb58bdc244752c233b483c96448314cc52d530058ac460d32420"
    sha256 cellar: :any_skip_relocation, catalina:       "1cc499e43e7e374cfa0abd52e70f39f1d5103581bb6b52149dd74a21f7344abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4188d222b5bde73d172ed24d0efc898228f96ed861e6d54ae2a22a69adef1bd"
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
