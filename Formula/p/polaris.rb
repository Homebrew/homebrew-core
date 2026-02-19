class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.4.tar.gz"
  sha256 "9362ff676f11301cf1a30753cb87e99c83370d9af95cc45886f4108e586c8894"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf552bf02817fedb4cd4a55f3133feeec626875a7cd89bb8fbcbad06a93956ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e2d6587f05c4decafcbe4f04b9a060d7ee874539c176705ab8a08eba876e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0253b28c5ba8236f7f6275bcd39c45db44d113f0c34904230f3d1b8c6aa32d9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "09232e850fb94cf0f8b9c80974321bbfb6f917edb4bab275927087ac4e2ad9a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97f4af56a9a265a8418cc4eb561374ba00947d8502cfbceef6687e2c391577f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067aac75823db39c584317689acbbb9ccbe15cd0f7274405495a15e0e99315d2"
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
