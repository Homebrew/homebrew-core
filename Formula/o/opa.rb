class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ef85e8a0f9f4804dc4578fa26fc0cedcac6a1efedb2b8f0291f6fefe5139861b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94e39a49537a87e5bfb1f6e636e6025a2ce0508cb1dbc012cb32217fac4430e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67bda8251f5644ad1b7fc569214ec337d0855944ea233999052d9e4e8ac18eb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7997283fbbfe5e6279802b65abbada40ac18ba32b64df574fd7f8fa9aa728487"
    sha256 cellar: :any_skip_relocation, sonoma:        "2415cda5c0cae247f4811ac846023f4667049c751ad1705d82123a823124287f"
    sha256 cellar: :any_skip_relocation, ventura:       "ff4ee8bc1ff6ca7f79bda12ed80f63c737f03ac8ed2db4b2a68528693cd67000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143dbba475e0de49c178e5701315ff883ef76a01e87c814e06bb5c61969cb180"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
