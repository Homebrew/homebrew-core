class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "cc45d71db67186022e0587d81fa50d82f0da05fac2723be1f188e5caf3655107"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88d255b3923b6b3fc6253d94367a2a398d396759a1aaea943f6834a1645519c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d255b3923b6b3fc6253d94367a2a398d396759a1aaea943f6834a1645519c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88d255b3923b6b3fc6253d94367a2a398d396759a1aaea943f6834a1645519c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5c9999d32150f8c616329946d9182589c2c975e35a75dd09d84c3b2b3f48a2e"
    sha256 cellar: :any_skip_relocation, ventura:       "d5c9999d32150f8c616329946d9182589c2c975e35a75dd09d84c3b2b3f48a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "514e891956612851d6b04b7ab624049fa95772391e02b8bebb62774c5f9ed0e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
