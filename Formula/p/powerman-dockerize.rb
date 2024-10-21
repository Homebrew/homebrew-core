class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "10129275fce05152bdb2448546fa37010555acdc2a93eca27bc4369e4fefc0d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dcf29fbdc5e2aa722327bb572676d8b15e97615b8a4c0a064d0ced8842d6601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dcf29fbdc5e2aa722327bb572676d8b15e97615b8a4c0a064d0ced8842d6601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dcf29fbdc5e2aa722327bb572676d8b15e97615b8a4c0a064d0ced8842d6601"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5479c77c1b8c894cc64ad7ed5d83c76a08c1af83990eb484b4bb081e8ddfa7d"
    sha256 cellar: :any_skip_relocation, ventura:       "c5479c77c1b8c894cc64ad7ed5d83c76a08c1af83990eb484b4bb081e8ddfa7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad64f3d377d5a1687f6d3be6e4057c316bf7878daa0ea2c5d1fdea24ca326de4"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
