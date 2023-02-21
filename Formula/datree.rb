class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.27.tar.gz"
  sha256 "7d50de13ca037b5308d4995b2ba7745296438d890087c6d400ece84463620deb"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480504207826213cd07f91cb2e0657cc852401b8bae4a02a82f46d346d126b6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5fdc148dd934f7b35b355c096e78cfd8cc9a4359a4eede182407732ebc5acd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d301dc4c4fe2addf164cf57f3513d5d10c66f29a1f97412541baa6b198698cef"
    sha256 cellar: :any_skip_relocation, ventura:        "f44324730972d7d9023cf538fd88f4d375cacc97cdc43b45681ef408569c5a87"
    sha256 cellar: :any_skip_relocation, monterey:       "7c6970e0d1838e778ec22abca3c0b857255670f70e9ae0f64fa46697527c3d48"
    sha256 cellar: :any_skip_relocation, big_sur:        "37345ef75229f4cf951792532d8e6b5e95dc082fe6a05e6162c64fab5deef7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3868b3753843bc4a2f4efffbf0b2a61b99d86a794bfc95314a604c80376dda8f"
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
