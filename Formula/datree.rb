class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.37.tar.gz"
  sha256 "a1458dc10bff2231fe74be5f335d7852bcd0547487a0be43ebdea19c6ddd9058"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591fb531aadd63f1f0994e8d97ae4e2de5e6ece27042d0351e76c94026c37f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735ac205d8d5323c68378e0073a9ea05bd4bb7b3c5a2af5e1b3d429a9c7895ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9033fd5b7e24bcacfe1381146facd9ad6b968e4b3a0b4183637e0c85add10b8"
    sha256 cellar: :any_skip_relocation, ventura:        "f0379158bf2f10f12e0b4d96e2f7d55fee6b5968d7ce81e6e4e3befc36588819"
    sha256 cellar: :any_skip_relocation, monterey:       "761eddb23d1c89953da97965e0d17b3ec8d45f3b47397863bd8b198aaec6e1fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "65182603075523faf451d159fcf23e391278f80b66d7a4617847b5964b79528d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22af2719c56c3be4d4e0a57543e83fe7f62969075d2406cae86a76ee41766051"
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
