class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "226d4ee3098ed90db283cba8afed43b1939638be4f39192f0a3d7842721499bc"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bee538a6d8d0f36180893980ae460d5829664a0437900d5465d1f3a8ba53e983"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1acb66ae33da31a7ed9a4e296c1d7c55729bb67d1185f7f9244909f8832e094c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c4560287dd42ddd00081aac369b57d309db5928e2d47806022539d87114f53ca"
    sha256 cellar: :any,                 arm64_linux:       "25331967747301283fbd465e9c3b719f5696af3419a29c916c06df63b7dbc2db"
    sha256 cellar: :any,                 x86_64_linux:      "15d8a5134f881583c72c3189b809864cc50c21ab5e2c030058b73240ee816e9d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
