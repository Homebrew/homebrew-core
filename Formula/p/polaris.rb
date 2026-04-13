class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.7.tar.gz"
  sha256 "82885a4b37c8eec82e01b7b084671cb8fb99495c259b500fc5398a40d60241d4"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db8707ab71fca149fe4d9ee290881580b90102fa52c195b075ae538658b54820"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee5f1db300430a319aade9ac9dcdc54d99d8c3c8ed3be006a71beef6866e200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d08138035e659b5d9681978820874a3b785dca7380c16752b79f1850ad0a4db3"
    sha256 cellar: :any_skip_relocation, sonoma:        "450625d9e8b6e4276243e1335701eed8af1d14a6a22d9198446da76f3c3df14e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93cdabcc4cb5f0fd996cffcc3c07f16d83a5eeeed16559faf60c5914179f959a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbacdd56665fb203f05063e356417bccfc59901bbc692638d171be8e186be363"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
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
