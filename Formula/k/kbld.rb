class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "4cd5c0c9d8fee4bdc6b91b2caf2072df04427d74c53a92ee32eca3085f3c49cc"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7f1bb8b384ec3e998664dfa802d6ffe2b45292271578d8bb69b1b6c3ec833b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f1bb8b384ec3e998664dfa802d6ffe2b45292271578d8bb69b1b6c3ec833b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7f1bb8b384ec3e998664dfa802d6ffe2b45292271578d8bb69b1b6c3ec833b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e52451eb1aae5b209ee35e119032ed9d730c66011769c3a8d3a617812f459b94"
    sha256 cellar: :any_skip_relocation, ventura:       "e52451eb1aae5b209ee35e119032ed9d730c66011769c3a8d3a617812f459b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4395ebf25b1d26792a00165507ff93e2f2c6b260aa2b3a43f4a07f007c0ad431"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
