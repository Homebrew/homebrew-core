class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.47.2.tar.gz"
  sha256 "2509ff3a756bed60d0140ab5d39aeae9202a179c4087fb8225ce236f8d870af2"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "030a7a151c85b29d6c7500807e5947601bf220cf2a50211937a824e30c37b068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030a7a151c85b29d6c7500807e5947601bf220cf2a50211937a824e30c37b068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "030a7a151c85b29d6c7500807e5947601bf220cf2a50211937a824e30c37b068"
    sha256 cellar: :any_skip_relocation, sonoma:        "809864101788a878d814c72312cc9e7417af3ddf931be4a159bba6b57af28a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2d43db60190c587dfbab3ef89660d038ae907d6a4beddf05d8f8340b0ba8a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f191a79c0d19d1305454403ffae8100cc4cf7f3c80d232979c22894e92553c"
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
