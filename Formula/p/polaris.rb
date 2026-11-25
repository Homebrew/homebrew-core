class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.7.tar.gz"
  sha256 "86697d668f0f9ccbb5e7b8d14910b0d9b609cbfa98796b72b5caf9244e7f81cf"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    manifest_sha256 "ba1110dd8794311c2a72bc0c93dfbb845f26f914bd14c851f6091e72f321e54a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6933d6ef32a40e293e5722ff52d2b0b59362fabf3982d80d0e33b5262ff3ac0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa5406c8dc4c79adf9159a8d6732de3e23871e2d25ce99e9996979e507f1031a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b4ab3ed41f90925d6b568a27512780a3641da24116a9ce06b29e22d765b17ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d0a0baf938e5ce9fe59bc9f7147753501c11c56803d845c3e6f764f6cadad2d4"
    sha256 cellar: :any,                 x86_64_linux:      "180115537bf0b5a306dc5f311b443d578e70df6cadf86200590d573d6b2604d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"polaris", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polaris version")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: nginx
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              resources: {}
    YAML

    output = shell_output("#{bin}/polaris audit --format=json #{testpath}/deployment.yaml 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
