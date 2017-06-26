require "language/go"

class Migrate < Formula
  desc "Go CLI for database migrations"
  homepage "https://github.com/mattes/migrate"
  url "https://github.com/mattes/migrate/archive/v3.0.1.tar.gz"
  sha256 "c3847f260e283929db8a39d8a0273db2f6c2d96ab3aee2dba7053a83f4b61e22"

  depends_on "go" => :build

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
        :revision => "8837942c3e09574accbc5f150e2c5e057189cace"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/mattes").mkpath
    ln_s buildpath, buildpath/"src/github.com/mattes/migrate"

    cd buildpath/"src/github.com/mattes/migrate/cli" do
      system "go", "build", "-tags", "'postgres'",
             "-o", "./migrate", "."

      bin.install "migrate"
    end
  end

  test do
    system bin/"migrate", "-version"
  end
end
