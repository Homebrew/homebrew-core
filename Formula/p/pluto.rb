class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.23.6.tar.gz"
  sha256 "8cd6f8f39e9e71e2c0f9391d61a2df6935f9d639729504cad8848290f1ca7b03"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fe718dccb4d47acc7d9168315d26cd26e9562110d49b55410ceeeff69d635b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fe718dccb4d47acc7d9168315d26cd26e9562110d49b55410ceeeff69d635b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fe718dccb4d47acc7d9168315d26cd26e9562110d49b55410ceeeff69d635b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0d5859d1c5e435cd3ede1eb9194883cbfdb2866b1623078542ead591c2e7b56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259fc2b2312fd34e532bbb99587e56e16f64b4062d31da2b07aa7770dec6c1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55374dbf35f843d0e0dbe6368c40741c1e0acf26b21a6b595f63c18eb47901c7"
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
