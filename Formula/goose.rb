require "language/go"

class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.0.0.tar.gz"
  sha256 "ebb5036ce89bfbb8e0594149454293fab6c2639873be824b0746994ab5a8668b"

  depends_on "go" => :build

  go_resource "github.com/golang/dep" do
    url "https://github.com/golang/dep.git",
        :revision => "c79b048e07eccf76d323d4c2e88d7c6d72ea735f"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/pressly/goose").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/golang/dep" do
      system "go", "install", "github.com/golang/dep/cmd/dep"
    end

    cd "src/github.com/pressly/goose" do
      system buildpath/"bin/dep", "ensure"
      system "go", "build", "-o", "goose", "github.com/pressly/goose/cmd/goose"
      bin.install "goose"
    end
  end

  test do
    system bin/"goose", "sqlite3", "./foo.db", "status", "create"
  end
end
