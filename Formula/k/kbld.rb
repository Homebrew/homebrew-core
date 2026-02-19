class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "a899543fd5ab5b54a10d6c81735606d2e8c90040ceda483a27ce5f6212022691"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9344c68734e9f252b577de9aab9b5861f52119a107a088607dec9ce1811511bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9344c68734e9f252b577de9aab9b5861f52119a107a088607dec9ce1811511bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9344c68734e9f252b577de9aab9b5861f52119a107a088607dec9ce1811511bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4363c9e988651d3e6d6fdf8eff70f22729d88da79d0bb5a039f10e1d1bfc3b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58178c062544d9478031df278a8e5d93f2e0bddc985048b5e7b0a430537746f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55a860f2510f5544926e51334089846717eb7f1fc4465da006b511c8f5cbfa0"
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
