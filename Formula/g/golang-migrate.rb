class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.18.3.tar.gz"
  sha256 "473342da619ce55bdb15e5ebcbcb6c798286b5dbd3f84f2884696b5cbe5d3d87"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7091a693b861947b28aaac253f9bc398e13dcf62161f95ede0040d8633c1a12f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b36344b56d5f04a2863f53fe5780a39ac20fe25e3a622bb15ea279bc63a81b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db71f8b6bde7fd8fa901ec7fc5f421b390fc872cd2487b40ec6c4d99da223eea"
    sha256 cellar: :any_skip_relocation, sonoma:        "913d3bc39a64f7b5cdefc2317d984b4bbe651450df3e01355a4d8b7fa68c08a0"
    sha256 cellar: :any_skip_relocation, ventura:       "7134d75640cc7ec9d2c6754c6284ac8f12c1130feeb1d45ba2baff7448e2d4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7b649961037f345925847b3bcf05964911f8889b825d067c81249c5cabe5146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07488c1089d7b70b9e316cc0775b241a8862a0826121db25354bd70e73d35d83"
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
