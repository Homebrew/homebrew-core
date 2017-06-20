require "language/go"

class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v1.0.tar.gz"
  sha256 "d1b84411dcb5abc211d52de65f1eeaa9ea4a1eeaee0400b3380d9d24e1dc8b1b"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/pressly").mkpath
    ln_s buildpath, buildpath/"src/github.com/pressly/goose"

    cd buildpath/"cmd/goose" do
      system "go", "build", "-o", "./goose", "."

      bin.install "goose"
    end
  end

  test do
    system bin/"goose", "sqlite3", "./foo.db", "status", "create"
  end
end
