class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.45.0.tar.gz"
  sha256 "d3bf43e9061b9fb3c66f23faa91c3eefe4074c4121ad403133303d2bab54bdb6"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "870aa4f973d9a1838ca2bf29be1b2258e03780d5b208c9a5db34386d00f49c35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd4b24f807eec994dc223e71716bc3110f91e0f55fbb1f27d208db6aa5ef019a"
    sha256 cellar: :any_skip_relocation, monterey:       "3659f888f29ff1cc7c659d4b60bd2d31fec7b084ceb3b56cab04b53b2386f8f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7df31cf86fc1e3dd22658a9708b31e59dd4a2cb3838b781e7e5f447e759d84d4"
    sha256 cellar: :any_skip_relocation, catalina:       "f49311e528087677ddcdb52d3e991ef8447a47823d1d019b01736f2b87056ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e154894628e98a5425a3bc2a02e7c4eef53d55b4977cfce7a42fcea9a0cc63f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
