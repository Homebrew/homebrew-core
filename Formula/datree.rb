class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.5.29.tar.gz"
  sha256 "f36b751cc9d3c22804d90674b609425ef79262e5fb0cfbbb0246de4713a60c27"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc2fc0a370630abc1d7fd77aee65d96f3718bae16d313c96e4bb2d7682111e6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fad99f5ce790b0abc5cbd5a0906d2abce65a883e70e977554781c414cbdf6440"
    sha256 cellar: :any_skip_relocation, monterey:       "8eecb798951881687f5231fc2b50224b72fc263d221cfe1e2515dd52ab7e9ca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b25c82c23fe5b7d6f0c31d611d9924109a5cfd82a30d85bdb0c02c4ebdbc94e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b94c01548f337221cd2e1e34547ef3ad3613653cdb7b9706563660f3a0e960ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d9f84b7a12bed8e91467d7d60b02a88143b051d2fa283ed0e724118fdda8ce"
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
