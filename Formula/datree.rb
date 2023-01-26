class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.8.20.tar.gz"
  sha256 "31df2145e99fc68282bc4713d2eddfef7185028624060f63e040fab36bb67941"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c330ae80bc9c092e4c7958abf0840cf2bbd819a4bb389cdd59d551bc8a8b84cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7b915b661dbde208883587229b62df01d809b7771b50601fba3a54916e76ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3e9e735ff32f1e3d360788802fc25a9ce2338461cdb360d849942ea73e028f5"
    sha256 cellar: :any_skip_relocation, ventura:        "57d17d5285535350fc6b628cae52d2c685d5db14685896eb07b6bc61033e34b9"
    sha256 cellar: :any_skip_relocation, monterey:       "e43caefa482683f467021c69a7977500a775df14f0007e56671a716f768874d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "07e3478604bd576d080a7ed55d688e70c26d5887f632eb3a41edfeb73f469b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38cfdb314867d294379fd586fae0aba67b9415fde42b3e8fe761007471bbc10"
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
