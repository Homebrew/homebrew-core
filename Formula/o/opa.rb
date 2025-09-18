class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "739e949f8646c1a6552d3222154f72d66c6b1c8f3373382199b1f368a3efb592"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8029dd0e55dc189a078d364ba5cbe200e92307dedc93cd0cfae8a54830dabe39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4660ed252a6c442c9c9de921efc14a4a72a71c9ae7c009c08ef7590bee10d054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cae863293d08e4d2ad9010a570217132f68107350994f5d749587cf1dbb0877c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71e2b6c349dc354803013d1d61ffc72e3f862899e2fdfba7c4a99cdeb9069eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "39236467077df9112eb5daab7793fa407725406c87b24578d7710801e375599e"
    sha256 cellar: :any_skip_relocation, ventura:       "e64e8bc13056ee0bda277658009cdbd2d1d965fa6f0a6705fe8a4215af582f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389f5252380738f92ade864a04d9283eadf5217ce0a965141c6843ef379978e7"
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
