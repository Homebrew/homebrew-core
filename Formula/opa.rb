class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.50.0.tar.gz"
  sha256 "936d6c9f7cdf4d428bfae7be3f72c20b6b1f1a84355e5c9497920803eb196709"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c9a6d03b73feb4f102b24484e8cc54737a57bf0131958682d9c858343e296cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd8f47a4a7b573579573a43432ffa019b2c9f986aa3ddc3e1323071c105f45b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feb03bfd7e34accc89dd83bf95b07119156c1c383dc63c096723fc28286980e2"
    sha256 cellar: :any_skip_relocation, ventura:        "b3fa95d0fb37d89fad4acbdd3a9d83d84f98ee76b40eec07d47ccbcc897e895b"
    sha256 cellar: :any_skip_relocation, monterey:       "776778e2355cf961ad812e91fc10a2276c5bc3cfd4475ee10b2cc52db85aa67e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8a115fcba54a1cbb96f8945429563ff454aa5fe2537eea438c15657012dc576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38cdeb8f6dff3c3a867965164355ceea90615779a7237e9c7e04a2c797fe18a"
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
