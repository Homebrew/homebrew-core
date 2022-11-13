class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.7.3.tar.gz"
  sha256 "9555f89e2937f459c1130a263f9cf2b0bad18586718fe97adde36c2187b81098"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3df124ab7b81d6f13a1dbc9d67d7e80b4dbec4d8237098d1013d386c6cc520fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04475690fe1d27008e6042a13db0852c6c65551ceea37962565ea5f28a621922"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "235092a3fe8e5b41b2bd854f1fd7e6adb7d242b69711256902eb2291a14a56d9"
    sha256 cellar: :any_skip_relocation, monterey:       "aceee13bc302e34e22a53e588580d37c9a9340fbcc53570531d07844a41cfb04"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdefb60c766eb538f3e37302165bfd4627025e206776442a8409cb8124e9d8b2"
    sha256 cellar: :any_skip_relocation, catalina:       "acb678801d34474e6379f3f751cad8ab41ce1b0b4fedcbc5876f45cfe233d1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b04f8973edf0088c675e0834974a32591b1ca62703d3c115a7290f2fe652d9f0"
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
