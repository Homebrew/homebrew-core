class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://mag37.org"
  url "https://github.com/mag37/dockcheck/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "dc2d3d23a422a7af7429b68815b22fba7d913c16229d66fc071de6cbfd1e2c9d"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "638964c5e3604a0cdcf90f79350105d7f5317bd8dc3e33309099192a11d3b929"
  end

  depends_on "regclient"

  uses_from_macos "jq", since: :sequoia

  # Fix `ScriptArgs[*]: unbound variable` with no arguments on Bash < 4.4
  patch do
    url "https://github.com/mag37/dockcheck/commit/7b6c7398a5338938e4555e804762f293b6e7d0f4.patch?full_index=1"
    sha256 "0def605fe272de63462431129d7b57117259a34c2d6f96b4036cc6ed5e53ec44"
    type :backport
    resolves "https://github.com/mag37/dockcheck/pull/308"
  end

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "user does not have permissions to the docker socket", output
  end
end
