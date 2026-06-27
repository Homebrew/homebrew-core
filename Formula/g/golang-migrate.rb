class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.19.1.tar.gz"
  sha256 "677bf03c19d684dc5bef47e981ec1b4564482cbf5f9b190cb48e110183fd6d25"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "756f6f4046cb091c66fb0ec1e4db160d07a7fd3b552aeb1d75adbbc716401332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d74478b5173dafc40af24aa1f175766cfc5278cbd81a04f5d83fd03600e27b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6b82e2fe5e03b8130f2363908a34d77b428ce3b7f68f629f9c93c1bd941fe94"
    sha256 cellar: :any_skip_relocation, sonoma:        "d22e7d26b80ff378d6d1dcac7ddf4e6f745ad60703d8b93068bb5e130fa84259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aeda2e9ddda567c4009f53efde24d8cd80610e55ee159c3c030a41dc80cece2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67548a520ac1995c4e55700f0eb2ae492d386690c2103c493c903791909abda"
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
