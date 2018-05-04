class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.2.0.tar.gz"
  sha256 "0d977417e60ba24fac7ba68f282e99d27600f583c3d7acd537b33f7afc7efdf1"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4389bdce9a88f2b7aca8e95539262f56e46720a54c956a79aba7bbf59134cee5" => :high_sierra
    sha256 "b7596059b7e270e7c41016eaac43052f3ceae1e628b32c6924f1de77ecf33705" => :sierra
    sha256 "31707ebe92ad5ade0adcf48754dd93822e2c95a0817526629ce9547e7130aee7" => :el_capitan
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
