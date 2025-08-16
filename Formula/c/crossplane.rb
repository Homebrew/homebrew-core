class Crossplane < Formula
  desc "Build control planes without needing to write code"
  homepage "https://github.com/crossplane/crossplane"
  url "https://github.com/crossplane/crossplane/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "dcdd06b770a6b697c8b9ba25ea7a96e4c8dd1fd4938a659ba49561f027cb38f7"
  license "Apache-2.0"
  head "https://github.com/crossplane/crossplane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67eb048cb737ca85754b113a8903d8ef61733ad1afc80a70991c8652fd9079da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8761db6a9225d68bfaf3675c0000e2cf86ca5ed13ff691d4a8e4e2e410256ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1a04558760ec2621522639f3c965084d43dc37a8774da9171da5580d9220a04"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cb9598aa99e945ae7bf04a1d6a6aca301f2ce095d19908f3a7f518b1271b883"
    sha256 cellar: :any_skip_relocation, ventura:       "8daf9a782f52ef1dc6a0d76e64ef481d57f76878728943ef83f883a0478fe894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c51366e97ec6fc0202803610b1c65c9e7e3523c5010a7d95bb0e7e0aa567786c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/crossplane/crossplane/v#{version.major}/internal/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crank"
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
