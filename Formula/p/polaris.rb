class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.2.tar.gz"
  sha256 "7a5620c1cf2d0f3800b15390d29cf3dbcfff6bed2ecaeb63baa75f4b4be0153b"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc6e6dc38d0d1a7e440bcee3ef651a7632f7cde833b28486543265a2fba16518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e947cc4f79927b4afe4961634aa340123f3b8bb0c6a31b4ef07a6e75a1a93b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52dcc4f2b89acaf18b766f86ac1a8fe363c065bad09bdcb64c3a8bf3dac808f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "956e5c31fb7ccc74512e131811642bdc7c8f5b0b9d80d2332eafaf1b98b6b3e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b540fd93e2ada0d086557cf39fa539ef8602e7208eee9974ca5c6e8233f1c3de"
    sha256 cellar: :any,                 x86_64_linux:  "f2adde68e36fba5883829401913e7e9210f0093461dca986270bf09a1ca01e1b"
  end

  depends_on "go" => :build

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
