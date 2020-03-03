class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.17.3.tar.gz"
  sha256 "998e6af2ed46f30324e004e075bd18ed9918159de6ddf4ac19ff2b2972ead9fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ddabcc0c5becb2cdcb1d9e45ac2da91d7f92ff4a27256ff8ec661eb3930f6b1" => :catalina
    sha256 "31d4588950d976623e409ba44e6cc50ee31ed7308e4a077b0adb5d67594a88de" => :mojave
    sha256 "8d08e9fefd8b0e402d3241b1404e416e892550f2d897eb38552f22cbc348477b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
