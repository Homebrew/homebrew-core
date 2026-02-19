class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "98b5bd6f1697949acccf33a89c6a60909b95f3d643046238cd92cb0732669e0d"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f11cdaaadf3434f6eacf93310f50f4b24cc3d5ff74ed48ca322505c43af781f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11cdaaadf3434f6eacf93310f50f4b24cc3d5ff74ed48ca322505c43af781f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11cdaaadf3434f6eacf93310f50f4b24cc3d5ff74ed48ca322505c43af781f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab1876ed7855b1165f7b0820dd03a7b7107e4e432fff92f194a31ca64a3602d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "013dd928d8a83a2e8302f7e827f417bba4ad5c0d4caab4e1d360a2b5a89e433f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ea8ba2c930682aec4943fd03d4684a500f026e384192c82d0db7b7038587fb"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
