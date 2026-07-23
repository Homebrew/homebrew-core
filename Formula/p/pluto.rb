class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.24.1.tar.gz"
  sha256 "581d9c8f04d97bf2ae55e4ebb523c6156ef408f0d400b13134ea1af67757a5a2"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91fa36ec8ca58ec09a34bf2bbe7c314439dcaf12b4254a7c5b3a6887e955623b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91fa36ec8ca58ec09a34bf2bbe7c314439dcaf12b4254a7c5b3a6887e955623b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91fa36ec8ca58ec09a34bf2bbe7c314439dcaf12b4254a7c5b3a6887e955623b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd7162ba653474a610c85ac07ee41bda0f749902c80a7f128dd255e40f623e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8861d430131a0b891d799943c631928cfff8a3b7727186366c8b65c6e37f150"
    sha256 cellar: :any,                 x86_64_linux:  "b04d40ba3325984eab2bab95552b0fa86a43d745fb97f38924c2c17315e7b75b"
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
