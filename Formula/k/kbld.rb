class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "cf22e37617bc01022e7032ce1eb45cc8c58a56c8a083b590b4cf3854382f8b1b"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37d91a8fbfa8e39b49273fc19ef879ffff8b74e1b15a43908864dc669706b41e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37d91a8fbfa8e39b49273fc19ef879ffff8b74e1b15a43908864dc669706b41e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37d91a8fbfa8e39b49273fc19ef879ffff8b74e1b15a43908864dc669706b41e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9a4a0c6bd8e14127766e818386b5fd6cc20fa61dea9bf46464e024ee145eb08"
    sha256 cellar: :any,                 x86_64_linux:      "7875993b266344dd0849db99fb452ac203a98b987d48706334b2ba6bfe7789ee"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X carvel.dev/kbld/pkg/kbld/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kbld"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbld --version")

    test_yaml = testpath/"test.yml"
    test_yaml.write <<~YAML
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: test
      spec:
        containers:
        - name: test
          image: nginx:1.14.2
    YAML

    output = shell_output("#{bin}/kbld -f #{test_yaml}")
    assert_match "image: index.docker.io/library/nginx@sha256", output
  end
end
