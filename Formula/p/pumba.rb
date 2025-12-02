class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/0.11.6.tar.gz"
  sha256 "50df612ecd3cfb2b99c41732f5ed80018aea4e4cdaa8dfee2a60ea9ff9d474eb"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38788444c09830d651974c980b94d4bab3032ffbb6cb6d228b447ab039c5340a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9f66c6aa33a8fb69c81a1da31157c7db688de6a28e774a09cea0c77b6a9d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9f66c6aa33a8fb69c81a1da31157c7db688de6a28e774a09cea0c77b6a9d73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a9f66c6aa33a8fb69c81a1da31157c7db688de6a28e774a09cea0c77b6a9d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "7449b4acb586f84c5de04d97f71c5f4fa56451e1437d46e0c8f001f53f5ac74b"
    sha256 cellar: :any_skip_relocation, ventura:       "7449b4acb586f84c5de04d97f71c5f4fa56451e1437d46e0c8f001f53f5ac74b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f6462686633e36b358e4c1fae0d050f51efb860c4bb0ffec8630ec4eaf1431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5edfec7bb124601265d2a2654435bef2118e3e6187d60b48e746a6d8abb9dee9"
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
