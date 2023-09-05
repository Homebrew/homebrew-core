class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.16.2.tar.gz"
  sha256 "df69eaf9a7850de282409f6a02284ddeb222c0ccbc8e7cc4719545ab62ef6d2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2f515ca7d39000e6ab7a2637a24b97450c9479bb7b8864ac36da79a5a875071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e1f5a21769c1f89858b20000f1763bc57cc22fc3d7d9cf19b3ec28592289fa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "581f5b92cdb2b93bab4e56e798f0b303423f9cd530323746e85f1feda7a7375a"
    sha256 cellar: :any_skip_relocation, ventura:        "61e5f0aa60ef5a03c4ba43846acb9aebc6f1bedb6e646731db3b9a9e9cf5560f"
    sha256 cellar: :any_skip_relocation, monterey:       "f7013038bbc60be6e5a693ee3bc5c429b01a76a8a5f008f74d6880d81d2c1992"
    sha256 cellar: :any_skip_relocation, big_sur:        "80b6de5aefc91b1739fb02ce357e3012b6c6ae17e169cbc5676646e6c37dbaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcaf86db4ff812d7249c022949edd5a3e6a5e7ad26e3d741ca24a743b53f64cf"
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
