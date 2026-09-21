class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.20.1.tar.gz"
  sha256 "365a1c5b517348301a540b04bda5d8778e61bff7e68583bcf2f278da570f4b46"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bfe86f1a15bd6797cef12d9bffe2c1f5ce6ce46b8f7643847d49fb2617c4ab6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1d4da9645c8b04557ef1f5443b07aeb5fc945c953408a7ea991a0109e346dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f95f3754a2615ab06e5140b67320277bb6d3dcae3592da4f8082c6e1ef08d0d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4202e10d5c045b6917894fe39c61b175f39219e2f567c9bd1c2bc3234061bde8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f47afe0b22a690003393397932ca3ef9d2880844e444af073fa6c7fe3dc19922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4594b9334c436e49bf4bac371c8702203fba23265a0a4050f96a5522a6b8e672"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
