class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "13dd23c8dbfc104cace35b35ab4894af815e8ca10e9da6eac811944d98e504c8"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b583c4cf67c9324506ce75542b2348941232831408636877ec73c3c9395eb693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc2aed78534393067a087f45703f317890ff004077e7411837e920cc3575c30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46a5d86461c5cba0d4327cf021263b628b7b8ae63ab2b55f2f6b4f0d064afdfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98830e8dff9a67b747512c0b3cefcbe26d8d2862f7c79dff9bbd72076ad6ff8"
    sha256 cellar: :any_skip_relocation, ventura:       "2aa4f6b6cc5bd0491a925769dbffc1118ec112a29cb16bb4adfb9c6657b39b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4596af3400d20ade1b86427c4ef8803213e4f919256280f6f2d7500bd1cba484"
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
