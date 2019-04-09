class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.2.5.tar.gz"
  sha256 "2146d2f5ab2c7886d4eaf4b5a7faf114231f86f5fc22b0ccf197cef859aef4a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "74fb0b67b0be8a8d5f119d6ebc90b44803797d96adfb70b8c4f1cb97a4fa2d9f" => :mojave
    sha256 "d4a593ef49ac517e8172ffe8a2927d15e2cb082f4ae8250f1634abf2a59b06ea" => :high_sierra
    sha256 "fed9aac30a582172f945eb806e783cc788d9450ff444632c5d40cfd57dbb9f59" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/golang-migrate/migrate").install buildpath.children

    # Build and install CLI as "migrate"
    cd "src/github.com/golang-migrate/migrate" do
      system "make", "build-cli", "VERSION=v#{version}"
      bin.install "cli/build/migrate.darwin-amd64" => "migrate"
      prefix.install_metafiles
    end
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
