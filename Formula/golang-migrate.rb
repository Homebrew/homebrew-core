class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.6.0.tar.gz"
  sha256 "ffb8e19e44b03e0d643aa99b4a1bd0f7b30d83c3973653c22610ba276a297737"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2f7995c74b38dbf223883083825f7656a9285566c7be81ee026eea16de5e142" => :mojave
    sha256 "f7126627c7937629b138c9f9421e9c2176005851dabd13c99a63c9fcb8ed9e31" => :high_sierra
    sha256 "df4bd491a6dcc4bd910c9a6a56550172ccfdd72f0c024b119ac4f982be831a27" => :sierra
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
