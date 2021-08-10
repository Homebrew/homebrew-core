class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.0.1.tar.gz"
  sha256 "f7b487d37aa37a27e9bf22d6fe51e205124999072922ce95bf0851b524413dbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3def952ad2ed85310f60466d350b65160044df5e9c3d7b7a715a177c9e0f7761"
    sha256 cellar: :any_skip_relocation, big_sur:       "51ceb50cb44e2a3907bbf7fb01398a6f2150ba20f7b110c668e73afccc9dfad2"
    sha256 cellar: :any_skip_relocation, catalina:      "d67b3467e39bf391088ee9c0deaf7781478ba269c4cf45fe5c542f3f854752e8"
    sha256 cellar: :any_skip_relocation, mojave:        "abf9f68a0c1e32a140b7d877bc89f69592bca2a00f1d1ae7fe722b6b18aa817a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc3e7d0b692cc6f134cf1a8fe264f2c507d0b33d3047babdd4069f6038cde652"
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
