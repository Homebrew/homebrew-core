class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "916075f3ca6ba6258905d67c559b57af7e52c1056f0b31838120b487e233857e"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abe483d78749fa2b397f430d924b300aec288c982e4b21d90dc1fece9915183b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce729ff0a4a64df10984a3ac8554bf79037bf19309541f3731aa2cf4dcde8444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c428ebc8db2c96f05fe3f99e36f889e7946597cc0f59f251c6eb6a11cb44879c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b8f9191429143fb3e88272be3b031b38bbef65124cd7224defa7920bce74a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "20d51fee5e0d34c356746be7cae0475a2d845ddb435e7a77df79afa3b111b210"
    sha256 cellar: :any_skip_relocation, monterey:       "829efa2d76346a898a17936d1cb208a47084d80efc85fb988fb48b664573ce10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9d23713f05fe379f7e9de0dfbb47247550d9667d868127c53ff2a4f84cec30"
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
