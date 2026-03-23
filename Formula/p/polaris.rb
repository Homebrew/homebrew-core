class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.6.tar.gz"
  sha256 "f597f47643d1384581c6f4f0b6b13dd2b80cef3cee1f9d4205e69dfbfc8cfe4b"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ed4373e7da28a437c28ee1144194291a170d8f12e4f2c0525d2889f639bfd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a9ac08914d8959306af1a8814d652da9163a20d1c723bdf24a627d1e1be847b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fdf71a8b9ad0cdd02a8b2eed23c0c946de333bc0df32d4e744384c0b7765e9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e050f0c36422708798ca528330c5dedf3a95adc84aaf513500342c9a334d625a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0084875c9d37df2511ce4639c562da2a816a36e6fa02ae9f79107b863f1001fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf997d627166f44aaa85f5cbedf30f470e9a4b1764e4bb9c3c7497cf135c5ba"
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
