require "language/go"

class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.0.0.tar.gz"
  sha256 "ebb5036ce89bfbb8e0594149454293fab6c2639873be824b0746994ab5a8668b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c785cc5066e5b6e30221b648611d2f50bd3df13088aeaa2a18cb1198810d975b" => :sierra
    sha256 "be5c3c4af5dccef6524ae911cfbafa530126c164c24346fa2074228dbbf3f46d" => :el_capitan
    sha256 "cd66c2c6f451491316eb0853b7d9ba7053ad5729ae1a258538438ced43397ff2" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/golang/dep" do
    url "https://github.com/golang/dep.git",
        :revision => "20e24628a053fd5da9d32598e75e80734717cb5f"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/pressly/goose").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/golang/dep" do
      system "go", "install", ".../cmd/dep"
    end

    cd "src/github.com/pressly/goose" do
      system buildpath/"bin/dep", "ensure"
      system "go", "build", "-o", bin/"goose", ".../cmd/goose"
    end
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
