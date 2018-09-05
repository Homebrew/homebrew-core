class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v3.4.0.tar.gz"
  sha256 "7a0789bf611d1efda95528cc581495fd9590cfa25d1dfc0be9e33eaf4c62e33e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a81861642c48b40945e8ffa6164496b49a9e92252add038d9dc0cf1e1082f20a" => :mojave
    sha256 "9b788b6efe7e4d550c1b990603c3dd52f3a6d200e29196958bf6aa92e41e041e" => :high_sierra
    sha256 "2cef73447b937c71fb1acc194cd10e25c2b44f84fc92ab134945ce86cdcb5a60" => :sierra
    sha256 "c48936e00e5c263d71c9c2bd4fc0ce295bc8191334e6862632e104e1fa79f73a" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/golang-migrate/migrate").install buildpath.children

    # Build and install CLI as "migrate"
    cd "src/github.com/golang-migrate/migrate" do
      system "dep", "ensure", "-vendor-only"
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
