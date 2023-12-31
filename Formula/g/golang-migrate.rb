class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.17.0.tar.gz"
  sha256 "21dd098636a80e270b7b381ad9c0a803249bf6f77c47cf172eb8566226b2163b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf10dedd07c64212ab2b7f7e580aa76e2150cf14a3609088556e0b63afba1a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b714880ce80513d3a346896553396ea09e4c66d1486df5ce087508dc730477c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59416dcfd47665f1868e11e894c665809df9ec392701c2dd11a745ee29ad06ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cc7b5897d293b134e2647649d6f5fd8a0ef5f15ab988af1b9872dd82012c3c2"
    sha256 cellar: :any_skip_relocation, ventura:        "b4ca022bdfb9c78e38ab9186aba9a3b1dfc438b4b39876534f8ccc66c6b7afd6"
    sha256 cellar: :any_skip_relocation, monterey:       "50d1c07b930986c64f960603aa128b853703c5e3aa4a2604b54a68685dcbf839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5bcff939ec1b176ec43199d73573dc1b7304283944dde1b4d52ca13f20d8de8"
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
