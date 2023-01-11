class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.9.6.tar.gz"
  sha256 "15865c6eeb108bc65bcd0aa6f3e270a7fed28854ea53eaa62cd0365c05d37f7c"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4ad75bbe7c3a0e73886d2661282d72547af9e1a49f9d70c1e6297973a4b9362"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddb60414c957448fd02b362a4f16a3f69c1651a6dc6056f4f2cf60077b722381"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d4c858512386d9f8b8daecf412489d664df66845fae69a1f7b9034f88815cc"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc660b24c816453471b746004178ce3f017f01c825c071f9f1c343163c55260"
    sha256 cellar: :any_skip_relocation, monterey:       "3eb10a1bd6ff5ea9b61c3c6c5b7e296601af2d5d02d00fa9b126142ff8de4e80"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d37eed0d572250c65b09f13668272a5591fd9aa4e62a240b3d6a0c38d495734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3752b036589a171ef007f5e45afe5c382adf06208b924dc2dbaaaa84fee8791b"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")
    # CI runs in a Docker container, so the test does not run as expected.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
