class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.12.2.tar.gz"
  sha256 "fa86fe006974551ff279ef3cef1b9855935579be4bcdf07a0732fb791903b5f3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f7cc816130bcb3adf2f2c61dd261e773528ea5b3fa8119fdd2f0559f6ccdf21" => :catalina
    sha256 "2ba0ad55b3abe5be3387b84f8f087cb264b29ac3adccd289e88b3e215223a21e" => :mojave
    sha256 "22857667dd2da00e9ad80ae3a48e9bed9fb66ca9d8c54d1f7da8d63b3ee84c2b" => :high_sierra
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
