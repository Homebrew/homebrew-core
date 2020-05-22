class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.20.4.tar.gz"
  sha256 "60821a77daa55e769c719b830c8f8715ddb9d4e6f1cd58ec80388086bb0b3b92"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71481ed630168d2899e62accffd8b31cf9df4326897efa3d61840ab4f7cc4909" => :catalina
    sha256 "7c3b2bec25efe350f26ead9443c13957c255b06ed63f670fdb9b948f763901e3" => :mojave
    sha256 "1d2959081af7ecd211ca59aacbbb0db3de7632f9d06e804f414549cabd6e196f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
