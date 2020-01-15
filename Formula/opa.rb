class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.16.1.tar.gz"
  sha256 "2251b905e7e6c416b71800bd779b184bce2302bd4655666c6e35e6d5c0e274b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "12a49903df2c7c51983f7a6b4b8eeb64c14eb251086687829001ff482f5f7228" => :catalina
    sha256 "e4f845f19f7e7018dd53a361f30745c8a21bc17444e7214bbba2cd5c8720080c" => :mojave
    sha256 "598ec6a006c15dba209e865ac34806da37716698fc05a6ce6dfd5f11acfaee57" => :high_sierra
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
