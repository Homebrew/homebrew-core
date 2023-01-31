class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.21.tar.gz"
  sha256 "fd25884ac9751ac0dca203b5aca62ea50dbc4b9e99282f4df5d3b6a95d439f2c"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0eb11cd5651d66cf7c5fde3cdc593ed2b59bfd18d519f8b4b66dfd36828ac46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c225cf90be4b01e354dcd12b5862db8fffee213a6b85528cf266fd828dcb4457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "862c7374d41c10f0cdf0981092607749316ba764573bb0bff40060bbdef51c1e"
    sha256 cellar: :any_skip_relocation, ventura:        "8800dc5466c7a45258b80fca9725c101f23b8f98729e123717dd8e9d16062d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "239da595429cfcb4dc407a358e002e0e1e77b4bd7546090a1a7d60e7b9decb6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b31e2419e4ddd300173d66a42ea5eb0b3c47dffa4225a4d8afa695ab9df0d7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54add1a69d141f40abf10bd2af73d787063864281cb4897656d2dc447131de45"
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
