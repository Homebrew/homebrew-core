class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "e79af618a610b7225a4a787de5e5615cba19f92d0b9a16f16e322c4a176522b8"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f86c6d80ede805265f9dec35b9d602f31f80483400e8b94f12b466866f5bb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f86c6d80ede805265f9dec35b9d602f31f80483400e8b94f12b466866f5bb52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f86c6d80ede805265f9dec35b9d602f31f80483400e8b94f12b466866f5bb52"
    sha256 cellar: :any_skip_relocation, sonoma:        "9234423a1e24611ea85cb216cd2d3555d98b202d2b977d69be9b0b3c53fb78d0"
    sha256 cellar: :any_skip_relocation, ventura:       "9234423a1e24611ea85cb216cd2d3555d98b202d2b977d69be9b0b3c53fb78d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2aa800d83a097307bf5ab3b3e5aa90f8d2e8a0815b973474a3f14c9402c392c"
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
