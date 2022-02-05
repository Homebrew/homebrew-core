class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.5.2.tar.gz"
  sha256 "295667d9f784d73be3a4728d4d1a4caf30f826892073c76983ea2ed8bd368c0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2353e68eb4fc9f222d965dbfc185aabb95818469e5db272d83d21967fb8a769e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efad649f90cfd0fffd84efad450d8b4371e0ae7d548e0b937808e32cca78a661"
    sha256 cellar: :any_skip_relocation, monterey:       "69940db8db2d226e8271209f4badc5102185934e4b766c497201a1654c43ad78"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb529a3d15360967f4831073cb4c06bdfd3c76f622e3e79415464951cd361c0a"
    sha256 cellar: :any_skip_relocation, catalina:       "bd85664ce428000e7d56fd3529966f3969bc0571ecc698a3fb74d439151dac0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e444b28ac225ee92121a0319a1378de2f02d7ddc2be33a7dfe92f32032619ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
