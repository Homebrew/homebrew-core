class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.19.2.tar.gz"
  sha256 "f8ccdf7ae2a9766654a8466b4287b5d55ad4b3f55673e45bd10340c93d967746"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "83d87e99850d165c8853c95f0525ce361fde1828e5fa0945541779a17574652f" => :catalina
    sha256 "21915151572c8cc2d4ba7cfaefd29f835b2eeb491577ac7a6aa40966d899dcb2" => :mojave
    sha256 "7f7ce89d126f1bc5392f90383059cb546e5118896f4f19cdf4ac51ce0ef242fa" => :high_sierra
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
