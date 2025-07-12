class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "4981d4128f2e156d5fe27a7d6ac7b9e70c94ffb8e9cea792e7b18d7fbaa4499e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77eb12272817fa2070e5ffff79c53db97e822776cee3b599cf1731c47b5bf96c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77eb12272817fa2070e5ffff79c53db97e822776cee3b599cf1731c47b5bf96c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77eb12272817fa2070e5ffff79c53db97e822776cee3b599cf1731c47b5bf96c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0613ab1a6aef4c559a4b566c13323fe02400dbab2698cad61fc6ea099908b0dc"
    sha256 cellar: :any_skip_relocation, ventura:       "0613ab1a6aef4c559a4b566c13323fe02400dbab2698cad61fc6ea099908b0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2fc4582b62b2b7bb8c7a947862a82f1e4e46e0a22c620a7d6d920ae5f8ef2a"
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
