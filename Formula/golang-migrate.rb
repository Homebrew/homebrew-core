class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.16.1.tar.gz"
  sha256 "e318e844e3ff71192edec91e9b69c1b6b3d8dfd4da986680f86e1178767de9ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adc27c1794d4f029222628d691c07eb7065ba037746d24cc77ece70838550881"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3439f1f50056e32b71cf054afc5f85d6b9842903df78d3c869038e69dcfe0e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc2b92245b4c3e9c1408252ed8c983fa89ae848631bd4a611e8f1dc34246ec6b"
    sha256 cellar: :any_skip_relocation, ventura:        "7ca14ad45aa3881aae6a6fec123f8298768440e0a41eb695072102ecd0c07134"
    sha256 cellar: :any_skip_relocation, monterey:       "adc0cfb4de06198c633b302faa0be5a674cdd87f2603b439f14bdaa5ed335e26"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d8b32d992de416698dacf6678343c91b3c7c72de6a38be69af26e39ce0f888f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ada0502ddf528c2809d74dd17039d93306b43e0ea58d88a075da66d3372f5c0"
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
