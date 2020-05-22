class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.20.2.tar.gz"
  sha256 "967b392919067eafbcba13bc206e38c3f2117f6d76fce3b5f16dd9d1446d9d3e"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95fb0307d0c5f5f8c338a91a93f5c2c2f6b19290de37ad74f93a703e53929c9b" => :catalina
    sha256 "9fe1c382d469ce7fac1c63111fbac82fb524d55a3df8a1d04f2ab0126401168a" => :mojave
    sha256 "c7e493c1ddcb596d8bd5af3b66d5a680b7c9f8d8bb7c11e668862f277d70294b" => :high_sierra
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
