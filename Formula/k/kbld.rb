class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "b6e5c4438d37dc0f034e58854948351f397000468b59deb50c00765f0ab1bd3f"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a5018acec4b842f03416925318e190b620b747a03595c6923db85e34e8be0da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a5018acec4b842f03416925318e190b620b747a03595c6923db85e34e8be0da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a5018acec4b842f03416925318e190b620b747a03595c6923db85e34e8be0da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "20680407743c8ee0069d1c11186234a110eb66b824493ed8f30143f60b330ed7"
    sha256 cellar: :any,                 x86_64_linux:      "ad7501bdd45b952b544f87d50c17cb35178e2679cde2b4d203b63a3851b767b0"
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
