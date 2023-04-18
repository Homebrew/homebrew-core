class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.15.2.tar.gz"
  sha256 "070b8c370fe45a2c2f6aa445feb65a1d63d749ce8b2dc5c7d1dffe45418b567a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ab03e86f6da0ff578e58b73282753aaeb86d2b100be34f54683a351069a4ea0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de335a1e58758ce0006b6c4b492699c409274b24a291ecb03612e104781093c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41595beeb24c80f73f2a3d1722ad29a03524dcf0d3cf3a40a1905a2d391188ba"
    sha256 cellar: :any_skip_relocation, ventura:        "ad606e8a29595bc3f0d20fa3e53ae15946144a991cf202ba5cfce0104fc7eafe"
    sha256 cellar: :any_skip_relocation, monterey:       "7d080cb0d06b0198228f7d0f74c626efefd9a6445155df5dce666745428c4bc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "10b7e0b3396058331b4efd8ebfb0fdb44cc1cda885ab499c89963ce3ca752188"
    sha256 cellar: :any_skip_relocation, catalina:       "f63879e90fea7b531081285580b10c5bc57d0585f35c3d6a3e178403a40f56cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8eda55a6ba9adcf3bb093cd0a142cdea1cd0669fdc151ed14a790e8aa5a575"
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
