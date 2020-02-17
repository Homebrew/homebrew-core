class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.9.0.tar.gz"
  sha256 "076bdcaf50258a15fbf731a8e4590eefb574b5267103e093fd71e1bafd0251ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d41fff633ecc854612e309ff58b8ad58f1e232aab19645d1d81401de29e185d" => :catalina
    sha256 "f79a25c573a2d40b44b562f39d549f13d88ca9ce8739deb55246cd151f7c38c6" => :mojave
    sha256 "40d4fa3853d18218e03e1cd27821afed05e40fb352a639225d2492b3506f648b" => :high_sierra
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
