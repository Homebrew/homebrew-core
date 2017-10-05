class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.1.0.tar.gz"
  sha256 "c5dcfab9b726e3ab4847ae1ab7dc7e3563623f2e0f815b350d7a87d40c3b161f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fe1ec4e7d10a1e834e92332b4dd052b0b109bd58d5a2d1dce7a4958360d8f6dd" => :high_sierra
    sha256 "048326604ea253142be6c5bd21b72f3be66cc8f26183f6d7ab1e51866e95a5ec" => :sierra
    sha256 "197a608d181b78f982397bf31793669f7b7817c4f4f9a59b390afb674723f2c8" => :el_capitan
    sha256 "5e53a301723864fef1e9c79b7e54d94e0da557feacac24869bb6981111ddd3b3" => :yosemite
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pressly/goose").install buildpath.children
    cd "src/github.com/pressly/goose" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"goose", ".../cmd/goose"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
