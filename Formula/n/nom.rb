class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "27e33b618e223d433a99161b3e401958a510cd5a4298ed77a6553c2a42d59d70"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a706a7b6c85b7a40ffb0fff9f86830b789ae58bbeab60d7ee3c9d9bf0166e30b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d3eea104317b7f35229620fbe22a9e77ee1f8ad1016812ec6cc1efef5bfe20d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a8282c6004b3fdd11db933825359a526d6876a02ef869eb45287efb138242d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b7912e34f9a5e6771f020d7bc29ceb6d855a9487e11a3144cc097541f3088cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1617468cfcb21474d39d55b80495c8c4021f902172028ecf6693d56297a2170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3846bd8d4cfcd4a2c6e40fee09d4e6cff5817f68748665cb89bbe3cdfa777663"
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
