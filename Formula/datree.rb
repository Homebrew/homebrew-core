class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.11.0.tar.gz"
  sha256 "dcb5e8138d878ad87cc171631ba1bc8ff29b1565e0a7f4ff216d98b7067aabc3"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8049ceee983148b6bafc700087954a10f99b8a95eef9eea7e636447ccd62c0b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4a0959f1c8da56cde057c5e1424c2ad817d5697803d1d51589a2ed8004cefd9"
    sha256 cellar: :any_skip_relocation, catalina:      "5fe2c5c822dc48580f97190e50e1e392d49ff34a3bb2566936d7ba376c7ecdb4"
    sha256 cellar: :any_skip_relocation, mojave:        "24341d1f09991d7e7d115e8897775aa7c5d6602c7036f737b24671e845e2a191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fca46a8f5d4d01ec05ab2b9ec942e8e7e72d7581104b7de51c1a7390c5e91aa"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/datreeio/datree/commit/c0c5fb1c1c8e5766969ebec09e7cdbbcc0f460f0.patch?full_index=1"
    sha256 "8d57c6f92fa0aaba07c79e2fe8312aea29ef40285dcf77d1397ea18cafe3cd5f"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
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
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 1)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
