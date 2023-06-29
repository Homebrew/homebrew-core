class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.9.7.tar.gz"
  sha256 "f87e367e8a820afec7c8af4c4229b90325b599ebc3a625c02bd85832e3352d01"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a778088850cac9805150a951c1230051ca066fc82dfaf7367b00f1c71d43562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84a989e71eb9ecaf1812d8511128462e8c74bb3f839f3fb700a06a072e6f35b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b947e5891984495e7fb48e6e687a865a82966d12d57304f57110ab141279fda8"
    sha256 cellar: :any_skip_relocation, ventura:        "8621f401eb31d4abb64136c73aa8d621af5461bbca9802af2e8cf5087c2b3052"
    sha256 cellar: :any_skip_relocation, monterey:       "2e5ee493fd6a7fb23d732f4654d78bf7a41754d1cf512359e200657b1e2c1e2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "633381d648f6e50e32074bda23669b2d609ae351bd643760697c4f70b2b19ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb72fe24587d4067ee01f0b7ed8f4a58124a061952be0dc0123196e509770a80"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
