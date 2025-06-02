class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/9.6.3.tar.gz"
  sha256 "137169603f1c68b0da976bd7c2b876c3a7e06e281eccbaea2657c37b80988405"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ccfe006b778c8f49eb585f5042ec9164039a229fb559753ec078c6c26fe165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91ccfe006b778c8f49eb585f5042ec9164039a229fb559753ec078c6c26fe165"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91ccfe006b778c8f49eb585f5042ec9164039a229fb559753ec078c6c26fe165"
    sha256 cellar: :any_skip_relocation, sonoma:        "e174637f3fef3c0fd5cc3ca45042f4102f317ea1ee57abca42b41c894e7932db"
    sha256 cellar: :any_skip_relocation, ventura:       "e174637f3fef3c0fd5cc3ca45042f4102f317ea1ee57abca42b41c894e7932db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58b895b961f875ee4f2d8db147dc206f00e39fc6586a36e0abdd114b69d0644"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}")

    generate_completions_from_executable(bin/"polaris", "completion")
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
