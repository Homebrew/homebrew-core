class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.19.0.tar.gz"
  sha256 "b659e7952d391b4e8adb4e84115faa8f1a15f74e6af81bd63cd8ed76e8f3f52d"
  license "MIT"
  head "https://github.com/golang-migrate/migrate.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7749a3d5a106e967a8b7da0be6da7f182e4e6747c5a8da0dee0316a2bf4815d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be176d438188ae1677c1c02150a2344742c22179f3542c790e20275f33ac9794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d60d5347090865c882dfcefe7ffd27e8fb145d81f3b917e1a2d276c37afeb06c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adbd4e5a206892db2d2625ecf95f0753fff1eb9c7724ad307611b422d10bf4b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "45540ac892c06d148e2186a270e45b553c251a6a7297c61e0431e589af9bef63"
    sha256 cellar: :any_skip_relocation, ventura:       "e250b1213930a80838c590f3992af52f96fb382c853d2f448285430eb6c270b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f207ca6356797f62545380dc7e1093cae2407b55b62aac56b6400d9dc6a984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c01ba5960f6fcc1de3c897500ec76f458b434c259a350727622b6f29207b1fd"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
