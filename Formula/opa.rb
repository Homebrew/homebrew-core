class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.16.0.tar.gz"
  sha256 "e351482e0c614e59c6a5e93c9cc619ab095fcf7c673582e1d467d844b7700372"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd9f195f5eb7ef262e4c16e86e0d0cf7239cbb394239457d45be9f7d90a5ed07" => :catalina
    sha256 "1fc065d1b835dce7774dc72b1efeb1fa8503ec66b413326c9d45018bfd85be5f" => :mojave
    sha256 "b0e09850835dfd34275c797d77f9aa944b3fb030729ad03b1b51fe72721415c2" => :high_sierra
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
