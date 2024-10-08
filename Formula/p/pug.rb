class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "96fdd0cc233f16553d3cf99c1b29d5abece105185dc3bbcf5a82af40c8178db8"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e62738d57b54eb2e283f0599f115211215931b434bfbffb60ad90038934f4fa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62738d57b54eb2e283f0599f115211215931b434bfbffb60ad90038934f4fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e62738d57b54eb2e283f0599f115211215931b434bfbffb60ad90038934f4fa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a177180b04b18a617739597ff67186897bd843846d13cff99b7e28aae80c0cf"
    sha256 cellar: :any_skip_relocation, ventura:       "2a177180b04b18a617739597ff67186897bd843846d13cff99b7e28aae80c0cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227133d27106d4618ac6a841a0548b8db5f1529cbe3fa52b4a34c385b791f4b8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}/pug --debug")
    # check on TUI elements
    assert_match "Modules", r.readline
    # check on debug logs
    assert_match "loaded 0 modules", (testpath/"messages.log").read

    assert_match version.to_s, shell_output("#{bin}/pug --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
