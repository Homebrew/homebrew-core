class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.1.0.tar.gz"
  sha256 "c5dcfab9b726e3ab4847ae1ab7dc7e3563623f2e0f815b350d7a87d40c3b161f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0780cffffd29b8cf0680e30a61f343b64f5cb190de2cbf47f4f7ca681e8afd2" => :sierra
    sha256 "dcf6bf2196cab49f8ff4d422ce706417964201a9e98eccdaf5d2f7134062bed9" => :el_capitan
    sha256 "8422c26d13ad5706c3c2f3e00afdf29197c43fc68d66fd2bc2b663ddd361977b" => :yosemite
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pressly/goose").install buildpath.children
    cd "src/github.com/pressly/goose" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"goose", ".../cmd/goose"
    end
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
