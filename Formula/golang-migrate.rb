class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.14.1.tar.gz"
  sha256 "c4bb59dd2a1c99980b453f37d0838d292aef9feab86ff5ec230f13e097761017"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c61a106d9970b0f9b14e78e1523894d57b50cd0473f7d5a1fb1a9161dbff159" => :big_sur
    sha256 "3565f7a03cfd1eeec3110aa8d56f03baa79b0de2718103c0095e51187ecd37ee" => :arm64_big_sur
    sha256 "a77af5282af35e0d073e82140b091eedf0b478c19aea36f1b06738690989cebb" => :catalina
    sha256 "8fa3758e979f09c171388887c831a6518e3f8df67b07668b6c8cebf76b19a653" => :mojave
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
