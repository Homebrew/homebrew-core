class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.7.tar.gz"
  sha256 "43f1fc3b93238e20c8adbbc133c4cfcb36c6b7ec8430ea22b24119468eddc09b"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f8ba96221b5047fdebe52d7f9f56238749b473b120263f84655feb9c4cf84e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8ba96221b5047fdebe52d7f9f56238749b473b120263f84655feb9c4cf84e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8ba96221b5047fdebe52d7f9f56238749b473b120263f84655feb9c4cf84e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "841f562aea4532e9d44d7a89620b0c2b34101eebf5b71970e098a47e26f4de28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c6d4a81f33ca1336f92099474b102e36dd021f03822257d19d17d4da2617b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe0a7a915dd007ca6136e9c91f27ae003f08dff7d9823dcbade902df7aa4061"
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
