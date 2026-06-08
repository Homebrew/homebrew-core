class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.24.0.tar.gz"
  sha256 "43aa23be269e1a61d184b295fbe092a81247803444386891a0df5fbcf42058ae"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23904731a597d0ad39e25f1e34d044406697cf69ce0c62b5b9315d0494dec371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23904731a597d0ad39e25f1e34d044406697cf69ce0c62b5b9315d0494dec371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23904731a597d0ad39e25f1e34d044406697cf69ce0c62b5b9315d0494dec371"
    sha256 cellar: :any_skip_relocation, sonoma:        "b293f3fac4ef553eb715b431e3b42f751c395e1e384568970c4e0c1fd5f9614c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4334b3081bfeb911849db67308af1bd1312df44c65f110594303f067a40cf3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ead8bec88be02d237b8f89f5258cf33cbaa91fb1069f3a315a4586fe45c2ff5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"

    generate_completions_from_executable(bin/"pluto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
