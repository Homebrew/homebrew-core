class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "44e8c94ffa41174f12e25ff60a9c7fd30cfd404b07b2332ec04070a27c2d2e74"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6986bafd2c9653962342cbd28f15fabc876a4c44f680626545b179d2cbecd851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6986bafd2c9653962342cbd28f15fabc876a4c44f680626545b179d2cbecd851"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6986bafd2c9653962342cbd28f15fabc876a4c44f680626545b179d2cbecd851"
    sha256 cellar: :any_skip_relocation, sonoma:        "1302d3d8bb8bf50e976566d1f2c3a63d41a352a19bd5cc102a87af6e7c9a5b48"
    sha256 cellar: :any_skip_relocation, ventura:       "1302d3d8bb8bf50e976566d1f2c3a63d41a352a19bd5cc102a87af6e7c9a5b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a166f60397cbd351bef8014a863d4f1529ee444dcce8b3359a24a3b8ca09c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/crossplane/crossplane/internal/version.version=v#{version}"), "./cmd/crank"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}/crossplane version --client")

    (testpath/"controllerconfig.yaml").write <<~EOS
      apiVersion: pkg.crossplane.io/v1alpha1
      kind: ControllerConfig
      metadata:
       name: irsa
      spec:
       args:
         - --enable-external-secret-stores
    EOS
    expected_output = <<~EOS
      apiVersion: pkg.crossplane.io/v1beta1
      kind: DeploymentRuntimeConfig
      metadata:
        name: irsa
      spec:
        deploymentTemplate:
          spec:
            selector: {}
            strategy: {}
            template:
              metadata:
              spec:
                containers:
                - args:
                  - --enable-external-secret-stores
                  name: package-runtime
                  resources: {}
    EOS
    system bin/"crossplane", "beta", "convert", "deployment-runtime", "controllerconfig.yaml", "-o",
"deploymentruntimeconfig.yaml"
    inreplace "deploymentruntimeconfig.yaml", /^\s+creationTimestamp.+$\n/, ""
    assert_equal expected_output, File.read("deploymentruntimeconfig.yaml")
  end
end
