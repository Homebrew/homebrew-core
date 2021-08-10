class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.31.0.tar.gz"
  sha256 "b2faf2b4bdf011569c27774167e8910d94dbb041f42456b5f1c5ce060958065b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b31cb69fc7608e2027a88ad9942041a9a9a5c4da9f78986b6643112a2eb6317c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1bb4f08953a1681351df7d3c9eb2215ff84e18a74c6d802a266dd28eb5ab274"
    sha256 cellar: :any_skip_relocation, catalina:      "3f61d74aafbbbfa3bf7e97f6aac37c3b7fd6486c41606b09f88e217b4c8f9149"
    sha256 cellar: :any_skip_relocation, mojave:        "aaa0494ef6630d49c797bb87ff2c1a3b4ae4c6e70ea6355d7e1772032b26da94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0609d2b47a32d6618062f34c8c287a66834ab3f1f31b317e4884431cf41b8d0b"
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
