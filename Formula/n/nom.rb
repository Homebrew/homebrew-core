class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "c55b6bd918a029e02704528e49d6ae554b41df745fcb1814d527b4eeca3086d9"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e22e68924dbc879cea8955b7b2a2568cce006f2e0056bfc7120a4685b4cbc9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2910defd62dcc9bf98653f8c54b2880547339bd91cda35d85509a6322ab87b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239b1ce257bab0439de6b4043bbda86ad4af5d194999e99aa2ba23431bddbcb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb4c6a0968b42dadd0eca9ba4249eda79c5d0c0569d4c4aa9eee941f9d934f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c359fcb800650693d52c76637211e23c58e19ca6e807031b3cab539f3b5d15ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25390d0521c529b5b019f90d96589e3d0aba4ee63af18047b8623518d186316e"
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
