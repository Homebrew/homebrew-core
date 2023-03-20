class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/v0.13.0.tar.gz"
  sha256 "1d29c86e674adb93645857a4e4ae0d18e0dfb404332b6c56466f43edc5185f1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0ceececc14c0307e9daaff7d8cdf32b58611d323c8fadb39726de1998398880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0ceececc14c0307e9daaff7d8cdf32b58611d323c8fadb39726de1998398880"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0ceececc14c0307e9daaff7d8cdf32b58611d323c8fadb39726de1998398880"
    sha256 cellar: :any_skip_relocation, ventura:        "afcf29e5d2706c91d0c5c4f1c7d7e2d9ae38c48b755f4ac45f13d559b829d22d"
    sha256 cellar: :any_skip_relocation, monterey:       "afcf29e5d2706c91d0c5c4f1c7d7e2d9ae38c48b755f4ac45f13d559b829d22d"
    sha256 cellar: :any_skip_relocation, big_sur:        "afcf29e5d2706c91d0c5c4f1c7d7e2d9ae38c48b755f4ac45f13d559b829d22d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "328f19aa4762680aa39e02380f50e2cd43228dee4198320c75647f81923800c0"
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
