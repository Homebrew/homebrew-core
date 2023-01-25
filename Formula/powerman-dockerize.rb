class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "41e95db5bd8924245913bd3701dc9c836a13cf629400886dca32767add45a0f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06eb3a12c19abec5377f796d20842521ccb75119514ab2d8dfb87571344d02c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d8483473bd0887cb591a80179330bf03eade11bf3426b0b5cc5f9ca1db75a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac01cdbe1462ba4cc911f665b58c856191aca8b87966e03442f0efaf711debc1"
    sha256 cellar: :any_skip_relocation, ventura:        "89a67b027be852fb2f2b4dab48e5036222a1ea3ce376d235c78c744763d73046"
    sha256 cellar: :any_skip_relocation, monterey:       "84bb03faade229edf1129c6f2fc5cb0eb9f0f98fcaea04ccd6a3af2343ea527b"
    sha256 cellar: :any_skip_relocation, big_sur:        "712f6f7ef24e03977b8c63ca5c1a2e951a397e0743aed48d6852adef417c3033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6334809edc1765e1315989e70285ecff9b68e713233427f486ccf4e0494bc34b"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
