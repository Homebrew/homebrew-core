class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.0.1",
      revision: "684c1805864e5f29acc204e34e1770eb74918d15"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dfeabbffb5e80a3a940f7194a11359f781aac85c8b9b74cf6b855e933eeb5a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31d4a1e6f6a7a76435f01170e3c0b76cc0a4ccd113b631c011a6d45eb925c735"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb7bc52e804e8fc152518b520d00fdc5c9b634b0f82d93c6581a57410dde18cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a68edfe06e07a4cddce766a066e295768e7cdcc98e2948ee6a4c792b5142f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "97a69a5459fba21867b2420cc44d99b09165f852c9b31521b7583268a66bdb01"
    sha256 cellar: :any_skip_relocation, monterey:       "8682fa5fa997403f315c7fad1ef2ff76d6f9e99b2f7bbf16662c055d1918f45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1f2c273b8a21529dfe1f296b8e52f116c907b283f47e41679f6227142711b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
