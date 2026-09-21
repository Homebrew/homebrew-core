class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.5.tar.gz"
  sha256 "a11095274e919643a0589080f99dcecd8f38d76306a87b803feebd7bb3ff9471"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d70d3d7c6b95cde5b398b172a2d2d318a80ee22c5454a295e9bcb22d34f025b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "836be60a8bffdfdb1a717bd747f9869944963689105d4819af4fae505efe9fe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e50b1304863b7682f64bf66f9a1346ff7425a73137b87fe94cf1cebcd83d3053"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e88144112279aac11d6ef8d7fc3ec4c403646e2a9f45c7d5ed7faf2c917f9c6"
    sha256 cellar: :any,                 x86_64_linux:      "a5d2a043c22253e49c8f512e9738229cc6b157a7bbf5c3fd37819ff2facc4ee4"
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
