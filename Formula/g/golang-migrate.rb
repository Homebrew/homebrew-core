class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.18.2.tar.gz"
  sha256 "a7bd48cd45dc2546f23f01750486fbba5b70b723500a881bb56221b11533a6f0"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27bccb4a8732c9c97fb4288b517bb883bc41e3f0d4eba25c583aca96439b32b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88030ba9649a79c89b55e9e3132891331e4b8d27b1d42885b040b91c30e3ce8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "735302297d56353649ddc448b8da7c852e44dc34dfc504c55f88af9f3acb825e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad5bea4c27a2b25aee3ba71eb0c2ccd35c549490e01f8faaa9728fdd774200a"
    sha256 cellar: :any_skip_relocation, ventura:       "3ddf0cd395b679e0ee43e5d0786a6c5d153dafb83c5f0a2e8e2b4db18f0a8279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a31847f6ffc888181e698137ab9f31a70744cc8f7c72dcc132829d06cd8de2c2"
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
