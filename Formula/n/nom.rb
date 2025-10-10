class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "c55b6bd918a029e02704528e49d6ae554b41df745fcb1814d527b4eeca3086d9"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "300241a110db1a5dc7ff70cb5bc3c27c6d9c293a37d818ba8c9b970a549cf1a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b344bf5c7d5048c3f6ea76c429895e016f5e6229be745e55f1b42823359fd98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2109a683d320fbd823649b8965294828c8f278df7338c34f9d1fd38e5a83bfd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "693e8601389023b3d62837b81023ce0379dec4059af86bd31544420173f3b442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4faaa9e2decb5a91e9f6a4430d89e443c180451b82b669d1caf3c1195a8ac1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bec2f45cd8dffdf80a1739c28fdf390089d904eb68dd8297a2080978b9bf940"
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
