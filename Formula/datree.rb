class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.28.tar.gz"
  sha256 "4dcf9689d8637871d1a19583ec3e6d201f60ee8dc354cf0f9b1cae21390ba36e"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16e32f61b797fa06a48532d9544a7dfa97944140242b55bdff1f45f1969ad56a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33c2fc3b01a643464c1422361834672e49775ca9989feb91fe30165f1d15ce26"
    sha256 cellar: :any_skip_relocation, monterey:       "d598eec4ac38c788714fe896f297594c069397dd7e81cef33db02d2f93681f2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "04105c814fe87980622bf0cbb66a4c287d1ae1218782583599577da64e7b1534"
    sha256 cellar: :any_skip_relocation, catalina:       "f13a1d5387e618e66a50a7e35ba48ad2d6daf591bc7908f9ad47fe732221f68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c47947691533ceddbe6a9662ad6efe81d230fa40c54aadf8a3bd4afdb1b8853f"
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
