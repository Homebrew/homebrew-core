class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.46.tar.gz"
  sha256 "68d104a3c244307f40ad26128a910f76ae549d2f776817280473b3f8128a7650"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3b0f58d620ea0120038e34ccd2d9a2ed5e0f3cdbd5e17b7277cb6233791d3a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d2b520f948c7f4d2146957c86e60d2acd4fb5fa2714508f9ba624013f555d48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e74a44646cf2efe4c6c693dc3b23b1bf62b7aba7752303197ffb7c82326116c"
    sha256 cellar: :any_skip_relocation, monterey:       "60aa946cc82e61bd97c7f52ff610cbeeb4afea66c8b3c631e96ad12c43617f7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "97c7899d823b8c8b087c97d07930bc39729db0f9d1fe007d4a4b3be22d814cca"
    sha256 cellar: :any_skip_relocation, catalina:       "02399fcfc1e5215f75b7a508c5b45b0c83bd875324b582b3f5f3f5e1c99c97e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540bc7afbecdd8dca3042a6f7901ee7c7824e289b03d897d57e1ed27e8cc0686"
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
