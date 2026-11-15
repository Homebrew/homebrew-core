class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.6.tar.gz"
  sha256 "80cb945283bf2c50856054fd07c924d68b755d9f52fdb39b2a009ed360c5420c"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d197fa7173fdab4be849fdeb9104ffbc6d25718ca621022d728c1b66c917d75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b2f44437e7a33be85b79c31ce5a4164c5124f1e7872bb6079cf647e72c1ac21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da5b92a1a88bf60c366e9337134a2e1883e158d88b9c3c34991cfb171b72ad44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4d287bfbf7d7fe440a55c6a4c4265d06e75bd55d688a410f0335afd8c31b0eb"
    sha256 cellar: :any,                 x86_64_linux:      "31bb3c74a2ca1641daa142784dc250ba94e5b0b4109a2495b7c754588e54dab9"
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
