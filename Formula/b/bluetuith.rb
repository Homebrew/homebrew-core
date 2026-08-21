class Bluetuith < Formula
  desc "Cross-platform TUI bluetooth manager"
  homepage "https://github.com/bluetuith-org/bluetuith"
  url "https://github.com/bluetuith-org/bluetuith/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "9586383c1703dd4e12e81f5f68e5144481aed8fb0526ee046dc3a80558d0f0dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "15579f6700793d2fc4c27a173cd839c994790a7a6e592f6a7ea9ed1fa9c03f93"
    sha256 cellar: :any,                 x86_64_linux: "53b21734919392d56bea9aa92cb1f546148e17176949445c56431564d49fc093"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Cannot initialize system DBus", shell_output("#{bin}/bluetuith 2>&1", 1)
  end
end
