class GhOst < Formula
  desc "Triggerless online schema migration solution for MySQL"
  homepage "https://github.com/github/gh-ost"
  url "https://github.com/github/gh-ost/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "771b1afd831a9e26eee045eb4f759d343db407786569619d2c77f1c186b873b5"
  license "MIT"
  head "https://github.com/github/gh-ost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f80872c648a99bed4e5b0df8448cf7b188809e722c80f939c4bd72895d650361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dab7c980d4d51cd755f4a3c4c1ca9f12b5b5326de4fb9f7c019a8fb6246c3e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "827efb6229793ce5b67caffc1f754c0184866d292434e811dc370ea8e63a831d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce09865234fee9ba0b25bec58bebfc4eac4b2342f143681f0ef9c0fe283c1149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db7f0c66138bc290b995a16e4f3ce79f7cf55d7d098e00f5656f60cfdb7db09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eaff5e09baab33ffb93ce3fd37905859e8e48b2c0a9f4910cd756c1591803d7"
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
