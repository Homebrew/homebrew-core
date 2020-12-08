class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.25.2.tar.gz"
  sha256 "014e7828b0530a18e23f6ff883502ae67070440707cb9c8bd9c0adf6d354caa2"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f9372583b854b412ea9c66ed387acb6dd43d9d7146f31e94451895f39dd8a36" => :big_sur
    sha256 "156b692756b114a0305070da54cb49c06c619d9ba35eb13041d6c596e3e399c4" => :catalina
    sha256 "b93393fa4447a5be190926086c97c885fb29eb273ba533dd8dbb06b5b3102042" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
