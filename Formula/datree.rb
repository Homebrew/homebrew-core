class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.9.5.tar.gz"
  sha256 "fd4525895e1d2eca7439526ec7f6088cddf2dc263fd92929b4736d33143199ec"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "699b3de0dcc9f55f5843657949e94ff1af60c8a70f644a69009886ba1ecf19dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c366d5993964ec1b8acb4479f00368dfe845229109d8f4ed510fea997703d73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4dc8e4e56eda69906fb1fee4e2aecce7e1bbb828658d6982ab10b07f4525a2b"
    sha256 cellar: :any_skip_relocation, ventura:        "6f6519b1073c7ad6119dd0b1a5d7e071b00aebe332b2f787627fd9439e0e3b5b"
    sha256 cellar: :any_skip_relocation, monterey:       "1336034bd4340605f140e155cf976d8c3323e063c5e9501287bd2bb2ccd3afd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc77a488e6e080a513be6e6260830b0e67ada067234761551ce08d457e640b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f0041f6b45759a14e0f0b7c228f8a212fe64cab688e4659feb8061872f894c"
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
