class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.33.tar.gz"
  sha256 "98d7413b1c3719682c0d7796543bc0af2bb5894f7b257996a8d3b4a584c404e5"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74bd3ca79b0521208cabb778ec256bd85de7080ac458ccb07528bdbaba239d46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285b980a9075a6a5f9fb21836d8f685a59efdc0eccc3c30ffd1104421633c801"
    sha256 cellar: :any_skip_relocation, monterey:       "881b246100bd7a926e88c8b4cb53fbf1b1062433956315cd72705ce707dd15a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f85d63bc21fce5af966eec2d52feae7fc1a21c5aa7514010bf3f522386f412d2"
    sha256 cellar: :any_skip_relocation, catalina:       "085fc00d3a958d91c2302b06ad2fcf813e243a90ec00200d9870dad81253f9ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266f81a2eef2a1b803ab6c74e76db98925145f7b80a267671698a38830f61a97"
  end

  depends_on "go" => :build

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
