class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.5.3.tar.gz"
  sha256 "9a5f9dc2b3b5f0876ad1e4609e1d1812e2b9ff03ea04e00c69ca05e7d9584601"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8c8d256f4798ea90d90c2391596b1e0894dede53ac48fa83e8310efe5153683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fcc9aad5c035bd9ad73bc1e7dbad0471f11b273c4a81d5f0411806969987817"
    sha256 cellar: :any_skip_relocation, monterey:       "117fc550382e79ba46fa25cb7271092be4fc8985d54dd62464db34e6e316602f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f28448c63ec85b699975b74a3d1f36ef92bce182553c5fd717666b6a8daa33dc"
    sha256 cellar: :any_skip_relocation, catalina:       "8bda3d2463277881f286c9d706b6acb3f59fff0d202b256dc395f385f71053b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13e380915742156334659ee1856db44460541d87dc2fa3c81cf9cf3209882d1c"
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
