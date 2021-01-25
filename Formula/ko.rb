class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.7.2.tar.gz"
  sha256 "425fb17b0c57a4dc292b6e1a791ec2428fca961a455f90aca67c27e17cd73736"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8488c9af3700981dc608d2ea7978e7fef2e5121b6ad4ab0271c27d91b547ceec" => :big_sur
    sha256 "3ec988fdaad4c36971343b6494d15e564bc853b02fa6097f76c23ee96bd6677a" => :arm64_big_sur
    sha256 "19f7ed87a0f0cdb666ef6880f10f2688ca9686d53b975164367b9720dc7778e9" => :catalina
    sha256 "16cd2e751b78b91bd6e65b8b396afbfad8ce211942adf9eb4b602c25e8a5b9df" => :mojave
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}"
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output

    ENV["KO_DOCKER_REPO"] = "ko.local"
    output = shell_output("#{bin}/ko run github.com/mattmoor/examples/http/cmd/helloworld 2>&1", 1)
    assert_match "failed to publish images", output
  end
end
