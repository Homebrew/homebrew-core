class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "e3cdfe735e1711c321b86bf93176125fa262765f1e2df91368615e0fcb9cd41c"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5914c94a7d11a87cb50da141d7913119bc5fbddce61e675f7cfe1f089f6b763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5914c94a7d11a87cb50da141d7913119bc5fbddce61e675f7cfe1f089f6b763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5914c94a7d11a87cb50da141d7913119bc5fbddce61e675f7cfe1f089f6b763"
    sha256 cellar: :any_skip_relocation, sonoma:        "e16f16bb84b8253db8d6880a2f7fd0b17453304854f5616eebc79b3309cee1a5"
    sha256 cellar: :any_skip_relocation, ventura:       "e16f16bb84b8253db8d6880a2f7fd0b17453304854f5616eebc79b3309cee1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0563374feb038a4750aabfa4bad29dd930832fec19cbfae4f9d0d8b12eb963f"
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
