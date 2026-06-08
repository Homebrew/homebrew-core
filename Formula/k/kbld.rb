class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "8589e54dfe3c6c6b25067d8f0715efde0c290766e4d9bf5a114dd3d97f36319d"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "370f4872218e4be900efc0a818e4cfb6dba7d4d1becf5486f9799d4d36332a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "370f4872218e4be900efc0a818e4cfb6dba7d4d1becf5486f9799d4d36332a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "370f4872218e4be900efc0a818e4cfb6dba7d4d1becf5486f9799d4d36332a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "016912f4f20c6a09a608bdb38704bfb8ff071cd38c26f8d3f2aae49d411372eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02db079d01c5c1b2cbd35e7778c0ea779350709a2e0c51328ffb183b36e7f9f8"
    sha256 cellar: :any,                 x86_64_linux:  "0a1fa00eda079c53e0a5ab15c0decaed26656ef6dc467c8f616cbcd9867f06c2"
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
