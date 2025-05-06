class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "dc83a2e91e05ec00ad4add22fb493bc1470868c5db6ecb9505010058cc68e3cc"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8d0c45851cc4654b7ac18399f87313e6ef78265e07c83fd7ee0ca35ac5cafc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb8d0c45851cc4654b7ac18399f87313e6ef78265e07c83fd7ee0ca35ac5cafc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb8d0c45851cc4654b7ac18399f87313e6ef78265e07c83fd7ee0ca35ac5cafc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88ad7b2e59f54c94ce5fc547a6d5c0f1d7aba483e67991583c40b85cbd3a083"
    sha256 cellar: :any_skip_relocation, ventura:       "e88ad7b2e59f54c94ce5fc547a6d5c0f1d7aba483e67991583c40b85cbd3a083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec9fee45d86daec5370121a792319019cd2ea21ce1f5784def6e4f79bff6ad8"
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
