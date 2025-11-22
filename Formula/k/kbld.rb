class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "5f6d6c454c6005e18aae7e2a127415db22ed90f5e23849807ef32c7ece6c9164"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae6504ee900e0ca67ed05b149dbbf9a5765c78137bcef34b660cb10a07f55aae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6504ee900e0ca67ed05b149dbbf9a5765c78137bcef34b660cb10a07f55aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae6504ee900e0ca67ed05b149dbbf9a5765c78137bcef34b660cb10a07f55aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "a074ea43ed088607fe0b13a8e84b029af9e66c651e37a503df7907774b50a4fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "435a067570ae3a3726bc0abcfffbc8e5879d21894bc26d8329d36999970c6622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62774dc7f8082a946fab059bd8944af4abc149bc14c49060311b2176a5bad1b2"
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
