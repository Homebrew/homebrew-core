class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.48.0.tar.gz"
  sha256 "73e499c9486784940e4d65d2fd1b23423c93fbf0dccd671289169ddec1141563"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "020c5f3297169eb9c0278e600831352130f2b2a3158e122c2db3bd6f22b8ded8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b001e22ebebc225da6c3cb87ae586563938b2faa40f26970fd747524971b74cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3294fe0fefa1b19679087984653a9287a030bc414882b70d0e86fcc4b7cb43ce"
    sha256 cellar: :any_skip_relocation, ventura:        "977e7cff654ed75cd78dc4f39826809591ad21ebe5beba241265ca1a67de26b7"
    sha256 cellar: :any_skip_relocation, monterey:       "78ec9d646bcedab03b874cb5f7115458b50e9cbde4b8995b2880dfe628a6abf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec3bd9699065b5e3272e7dd4c6ae2d065fae282f15cc5accb3ba7017e654b55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ce0d342bb70197fd0f38e635efb8d08c55f5b3920151b38c558f37340a1bb82"
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
