class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.13.0.tar.gz"
  sha256 "df0886dfdff9673eee847addb686018757a55b7c8168d5ec38894af68cc3a725"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "28671b6f56dae05955d764980d8897108190963de59bb6abe644562739ccf23f" => :catalina
    sha256 "e6b40d8432820b196404a88b78cf632ab28126e3d40926b3752899ddc6e5b273" => :mojave
    sha256 "da723ed227c579e8372ade7bde2d2b97ba7732048070c2adde2ad62f7718b1d4" => :high_sierra
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
