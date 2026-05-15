class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.47.3.tar.gz"
  sha256 "bd9283b80ff490999476bae87931bb8f2b68b045e2bf951e732c72303df612f8"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f094081e4299c32c850ac74a653430875eba29ace732f90913b593daae97979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f094081e4299c32c850ac74a653430875eba29ace732f90913b593daae97979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f094081e4299c32c850ac74a653430875eba29ace732f90913b593daae97979"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef12606efe55f02c73c2624d2742edca23335892f30c62f56c93061165a0c250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548e25667e2a156b9f525131480d41fce5b6bd826bd4e23480cd1c514b8f30e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f23654f955d3046392c5d51ce6e14cd3e4f7d72a34fab1d2163cdb5e1d6a149d"
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
