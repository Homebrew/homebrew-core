class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "679bc0856ca7ba2f1ad37ed66dbe1bcda56bb9e8b72003c087a380cbff417d13"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8035b7528e0607a713fe8d00b2661579f592c4f6928c5042dc9b72c92224a3f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5dade0752544d32529edaad0588ff1307f8bb0479a8ed4843b3681e7f025a7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd9a9d2bac243d3278ec891d9cea87abc793ed4f59243e896265409cfbb3d5ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "10419be6c7eb242727697b62cbf26b7385750967e10b39d75cdbbd8615bdbe84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e698f07d26fb81aa04d1a9aff5d160d7f0f4f0a433ebd1f6ac3c340fab5e8540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebe21dbbc0795eec81e9866a28c8d59e2e52455fbeefecfef303838a2fd4fd2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
