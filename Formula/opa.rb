class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.17.2.tar.gz"
  sha256 "e503f396b82471a42478c10621855e2de905de5c13a2700db601b00d4513971c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6d615faef042bc59e6566194e043d301b825755c1ebc9dbb3b5ca67cc0e2fb5" => :catalina
    sha256 "56d55b86b0670c2778d9e91a19c0088c929429354f237efbf65a8ee361b255dd" => :mojave
    sha256 "4fb313fcea59e5ca1ed3438288a8a2b2ee711b6494dc5d4f684e9f814e2a7362" => :high_sierra
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
