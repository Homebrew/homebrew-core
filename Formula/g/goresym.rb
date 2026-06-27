class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v3.3.tar.gz"
  sha256 "e0afe3faaf824460b611a1ef6e93015341cfea999a6237516c15b59f8936d3f0"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af273cd572590e674ed4e1f6b46dabdea6dfc5b145a788c371f526a640bd8b48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af273cd572590e674ed4e1f6b46dabdea6dfc5b145a788c371f526a640bd8b48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af273cd572590e674ed4e1f6b46dabdea6dfc5b145a788c371f526a640bd8b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a30484f5167d0a9f066a9b7a3472541644c5952566177f7781575ee27ad3d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfbdb148c231c39227cc587681bfdc3c63057e646b158203b498d981d24ad6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e43efb77993fb2b917d19cc1422fbdee17fc32b3a16b901f90087c158b1118"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end
