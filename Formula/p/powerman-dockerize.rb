class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.25.4",
      revision: "c10dc89747f004c236f869f34ee371f527d68b8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf441af60946ba3b6429342c0cca568f4914640a1267ab839f132da1094153f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf441af60946ba3b6429342c0cca568f4914640a1267ab839f132da1094153f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf441af60946ba3b6429342c0cca568f4914640a1267ab839f132da1094153f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4527764269a56f9ba477b23088ee18752dd7eeaf8b0b3806d54a210198083ee"
    sha256 cellar: :any,                 x86_64_linux:      "68828fe53d7582b234eed3b0c7c243aa2693efc8255aeb92ae0515d245680d73"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
