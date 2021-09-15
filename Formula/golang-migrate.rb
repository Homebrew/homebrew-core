class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.14.1.tar.gz"
  sha256 "c4bb59dd2a1c99980b453f37d0838d292aef9feab86ff5ec230f13e097761017"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3565f7a03cfd1eeec3110aa8d56f03baa79b0de2718103c0095e51187ecd37ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c61a106d9970b0f9b14e78e1523894d57b50cd0473f7d5a1fb1a9161dbff159"
    sha256 cellar: :any_skip_relocation, catalina:      "a77af5282af35e0d073e82140b091eedf0b478c19aea36f1b06738690989cebb"
    sha256 cellar: :any_skip_relocation, mojave:        "8fa3758e979f09c171388887c831a6518e3f8df67b07668b6c8cebf76b19a653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae2f9b6663ac11a178757ecc67a0407a89191efbdb76302a665566951b7ca34"
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
