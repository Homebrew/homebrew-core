class GhOst < Formula
  desc "Triggerless online schema migration solution for MySQL"
  homepage "https://github.com/github/gh-ost"
  url "https://github.com/github/gh-ost/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "0c5450e61cac940a6daaff22463ee6205b84c256b981ef047e0b4c430a25eb4b"
  license "MIT"
  head "https://github.com/github/gh-ost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1c71250037404630df76c18f252118facc474b5e2a6769c6558fa5f04a105cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f0e3f8dc64ab186702813b749dd5fec589dbc4be6476b8f6ae11f6a436b1ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4400397d24ec74720312b23d489c8b18d0e6c7086bc48c09a6f7b7d094a1197"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a874f959a202e74254c85181ec8d97b8036f735692b05cd6793785a4330efcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a5a7358c74cb32e12754c3a2aad575f6cd6268b222a122b99522add63a2ef20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e1ba3b16e29e6d0c3069a50adb4fb3d6bc7bb8e2c21a9146fa84bf48040c66"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.AppVersion=#{version} -X main.GitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./go/cmd/gh-ost"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh-ost -version")

    error_output = shell_output("#{bin}/gh-ost --database invalid " \
                                "--table invalid --execute --alter 'ADD COLUMN c INT' 2>&1", 1)
    assert_match "connect: connection refused", error_output
  end
end
