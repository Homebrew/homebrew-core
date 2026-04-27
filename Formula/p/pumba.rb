class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.1.2.tar.gz"
  sha256 "54246ffc2f9d95b56b9bc2ab9fda350032c67ac2f89eb824c5f023b4362a88a7"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d4a3b2be3f779ba127b57490708624ce0c2c504672e88820f043b5f6a523ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4a3b2be3f779ba127b57490708624ce0c2c504672e88820f043b5f6a523ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4a3b2be3f779ba127b57490708624ce0c2c504672e88820f043b5f6a523ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbef449fac86b2961157aeb0e1fc55c15dcf4d40948c32393c628a6517aa2dcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "932a901201c52029bdc0fc30d1342aadfe61737a7a14bd13ede23f1596887fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a330589836d75635c39907b745bf1ed84afa85e14b09dd258ef0e1c291924b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
