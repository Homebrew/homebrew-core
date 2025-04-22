class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/refs/tags/1.9.19.tar.gz"
  sha256 "a8b6bf3d3cf0e325590ba3901db6a00e1a268f4a0652f9892af3c7c98efe196b"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "035d6e28e854bc8d9eed9dca0248383b78e2630f639777546ca5eee4689cfb41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "275cf0f3c28393d717867f2d22a04bf626d1b819bec4e49e90e8f93ebf32da9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "313779ac5a9953737346a6b4ffd0f33b1992a406bf065f92db9cb3658e64de77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9abf7cc92fcbd039333ff189b6ddd620b3be7cabd7078c60e254c0667fee21a1"
    sha256 cellar: :any_skip_relocation, ventura:        "e8dbc00a2dc36b8e3aef0802b5cdb7ff93a28de799ce708f64a9ad1a1f1db254"
    sha256 cellar: :any_skip_relocation, monterey:       "299cb372940354ddb7b9849ba09e6bf777c541f703d1d4a892452bbb58f56f47"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ceb9370ceecf72744d60f1705df1bf65514f5a17ee3eed4b582587c66a3e10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a786ae16a4d3a8ae959cdc9f6571df8e528822389f852c5ddaacb9c27995492"
  end

  # project is deprecated per https://github.com/datreeio/datree/pull/964
  disable! date: "2024-12-22", because: :unmaintained

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/datreeio/datree/cmd.CliVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "main")

    generate_completions_from_executable(bin/"datree", "completion")
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~YAML
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    YAML

    # Set to work in the offline mode
    system bin/"datree", "config", "set", "offline", "local"

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
