class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.37.tar.gz"
  sha256 "c6cfc3a128b73dc40191c34b573981eaf506ff2a7123152d1562182b6e1d6d26"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb7d6e9c9278d65c3ecd3a81f586e3baab5e905e5eecd8813f1b90aed357367"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02928fbc5cfd611cb918d0662eae6005cb562b275307a52bc97fbe88905c890e"
    sha256 cellar: :any_skip_relocation, monterey:       "27205bf83d031876816affecba07cfd029036942b47194f2d96ecd40d6b25672"
    sha256 cellar: :any_skip_relocation, big_sur:        "2709862af16af3c09262197e03d02bb6c2daa4f1bd12340d9af371e52f1d63ad"
    sha256 cellar: :any_skip_relocation, catalina:       "d8089d9899260199e3418c674a9d0ebd27ae213da6f9b289b5c7fe848c6b0c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9478a80a3057c25d943c7b37197005c6fcc80cb02622a6aa7b3a0fadef4ff1ec"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
