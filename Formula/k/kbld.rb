class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "44b503eead99fcfcd7393c4bbeb61ac1cb9c0e97f5a294b762297c6a547ef730"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46f890b2bb567d4fd127c8c3ce49355010d66903bf21aa1179386dfcd936b345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46f890b2bb567d4fd127c8c3ce49355010d66903bf21aa1179386dfcd936b345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f890b2bb567d4fd127c8c3ce49355010d66903bf21aa1179386dfcd936b345"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eb7ec727ca70a67f737d91d1577955bb26a64baa87e1e285dc45f540f54d703"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a057812c84ed737069a4eb9958257494321beeb14b4aa4209ded31146530969a"
    sha256 cellar: :any,                 x86_64_linux:  "0d9b39ccb0959ecc8a60434f7cc431fe2691df7542cc9c7aecdcaf3df933a40d"
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
