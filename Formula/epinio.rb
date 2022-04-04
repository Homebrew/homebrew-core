class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "37cd7536aa8baf165f8717b2f5ec895045a53ac2ca4fdbb808354b20736969c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa0a592fc84b025c0e558300a2feab9229d0e2b105265941a2189eaa7ddf3dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38271b9c3f2fb336a420789d5d369505ab2c381e5e3cb19f660f09cc08880922"
    sha256 cellar: :any_skip_relocation, monterey:       "0e44fbe33803626c18f8d16f3aa0f1176364019229ca518ad32032070b8ec846"
    sha256 cellar: :any_skip_relocation, big_sur:        "694d80845f198c73c337f42e15bea139940e8827afdbf68b26f0a143c3663fa1"
    sha256 cellar: :any_skip_relocation, catalina:       "3476de9b6f59c73d0b447bac6a0e62507380c49d0dca90492f83a7ebfd2bd1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89141a8238d8d124d9b509df98bf4158ee6e322fabe69b551dbdd1f8c1429a8a"
  end

  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
