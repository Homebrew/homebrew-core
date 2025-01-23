class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "3f13e256fedf3c775ba23cad6a1664aa2091b89ff6a0d1e4fc44db7014d32c43"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e27b637209991db9ee3d5b699d91145bbcda0133479f3dac1fa143aad76ca5a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27b637209991db9ee3d5b699d91145bbcda0133479f3dac1fa143aad76ca5a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e27b637209991db9ee3d5b699d91145bbcda0133479f3dac1fa143aad76ca5a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f611cf1fd19c654c4c32944e60736bbd51c50851c6fe28fd66195d053e8da1"
    sha256 cellar: :any_skip_relocation, ventura:       "79f611cf1fd19c654c4c32944e60736bbd51c50851c6fe28fd66195d053e8da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67590d7ee5199a011162a17b7fb05613a09c9f445a620b48061c0a6608b75d60"
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
