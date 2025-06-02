class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "19bc2126a636ba9e67b70de951f69854c85e13333ce01329bd8356a2696792c5"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3c0fa4e896acbca0d698a7c6cf9831de2c64fac3412d38ccf9c1501ad896df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df018239abfffd81c0d556fbfd9c31abb59a8ef276af02d55bdbeb8789179621"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1094404b8fbd8b73c726825cfb042383bc82074f086c13865f7270ca1bd19ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "337334604189b629066db5daab3cb40603683598f2456891c37157e8548f628c"
    sha256 cellar: :any_skip_relocation, ventura:       "96466ae3815085b90101c68c18c9e281f71b09fce1a3728c8c66503c8b1c4b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "586e15acc3c504a23fe4b06968a92f39d11dcb61a0e8e71a128aa6f4882da46d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/crossplane/crossplane/internal/version.version=v#{version}"), "./cmd/crank"
  end

  test do
    assert_match "Client Version: v#{version}", shell_output("#{bin}/crossplane version --client")

    (testpath/"controllerconfig.yaml").write <<~YAML
      apiVersion: pkg.crossplane.io/v1alpha1
      kind: ControllerConfig
      metadata:
       name: irsa
      spec:
       args:
         - --enable-external-secret-stores
    YAML
    expected_output = <<~YAML
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
    YAML
    system bin/"crossplane", "beta", "convert", "deployment-runtime", "controllerconfig.yaml", "-o",
"deploymentruntimeconfig.yaml"
    inreplace "deploymentruntimeconfig.yaml", /^\s+creationTimestamp.+$\n/, ""
    assert_equal expected_output, File.read("deploymentruntimeconfig.yaml")
  end
end
