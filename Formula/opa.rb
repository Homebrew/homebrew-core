class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.51.0.tar.gz"
  sha256 "30e40d6580f2e55e378fed2d9c59771809a98e9fe55c8103800980fe017aaf4b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bebed2590c37d4cff4743151db475310181d4a3a93d8cff0793a0c7682f0596f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6ae61bc32d3faa6727fafc698f1350aa1aa0d95978da9d501dcee724f30245b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f608ef74308b348c322820f48d48a01a666ebb07c746031d1b5c0c2b910ea114"
    sha256 cellar: :any_skip_relocation, ventura:        "783462a8e5b5c7037f2c087347aa30968342d6bd35c7018c004932091dda3e8c"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d89c151ad672b7d20dc1fdd015e38f2b623e2e719af03941a4d20e2a923b10"
    sha256 cellar: :any_skip_relocation, big_sur:        "da9929ccc81e18f6bbef4389f02083a73ae0592ffd2324082e4d1cd0fa95d718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52aab83c4b3754c170004cb1f93bbf611b438a2f1a31815a6b8b380ab08bdb8a"
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
