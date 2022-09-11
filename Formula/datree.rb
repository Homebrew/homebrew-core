class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.19.tar.gz"
  sha256 "012a43e0a3005845ec00346b1dcefa38df15bb0337c868ae8fa95dfb174a12e7"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daf49e2d05308163862cdd4d1f951e010cc81b948d1474689044e4702c5e8eb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8edd9e108b62a3de7f0b28c6b910e015b20915633ea0b17f13caa21cf61c47f"
    sha256 cellar: :any_skip_relocation, monterey:       "70716c821a4a4dae71d5f5cdd38d57b7ce291556f6c3cb54b8dbd62eb774599f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5011f20f59fe255d0b789f466efef56ad4dbb43c9c1bd897abaff1f6d7ff98bd"
    sha256 cellar: :any_skip_relocation, catalina:       "4a2740776ce2ef37b1e0863bbb2af581d2b486adfaf8f4ce7ea33c757f7b0ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379bd3d07f505ad70d7900044a896b703e01c758ba7b89dbdc65ce6383db8da9"
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
