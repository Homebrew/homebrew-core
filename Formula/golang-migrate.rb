class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.0.2.tar.gz"
  sha256 "8cf4a1bd8686f07ef9941a8c5bffc2378d04bc3597879b8f7881a9384d72f420"

  bottle do
    cellar :any_skip_relocation
    sha256 "da2c0b0eba6be112d73c2fa4c36d34731520a4ed4bae78451137ed387a8c4b5e" => :mojave
    sha256 "f902a4d1776bd1aea2dfb45bda5a4310a44b8041f203221a13d144cadf496327" => :high_sierra
    sha256 "c76fd391b43c9e1081aef954d9f8a9ee1e397e62a6eaf03f6799bab5480066d2" => :sierra
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
