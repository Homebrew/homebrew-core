class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.7.0.tar.gz"
  sha256 "704feecc502f08b69e53135df3125b88f6b94174c51448c8c5013dba7389efa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6855ceb3f8e7de6a7638ff1043a9889ab90fcbdd81369cacda350fe33243a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b28391bc5fcf1264b569969a75def962c7038bd15d9bcad1ee7d1e42f65ab578"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb17bf9ca19827f461ca37f5b2f217a5759e42f70e80ca01af7b7a71486c7868"
    sha256 cellar: :any_skip_relocation, ventura:        "dd11aa35ddfdbfedba993a771e746c8956658add7bf0bf782c86c5b9395cb333"
    sha256 cellar: :any_skip_relocation, monterey:       "c5eece958501bca979bd4ee591ac968586e8e7154f942ed61a6f34541c8ff82a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f800b1c38609380e8b40387de9b27d9767f1389e8ad06ec3ac3873c64d9d1e49"
    sha256 cellar: :any_skip_relocation, catalina:       "a52b21a484a4f8209e41cbff1916c63a6c4f399a2d4a6aa8ddc1a1a74e93ee62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e0e33d60de35120af7be5c5f08eb2ef00407c953cd1dd1bb67441280a1ce525"
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
