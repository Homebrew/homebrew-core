class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.2.1.tar.gz"
  sha256 "304adf11736d0948d29cf8d8840ea1e489cad33648fca368de00b2f051e73e9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "afaecd6f9272937892282628f6d7a08ccbd21119a6393ccb9ed7e22e19fddbc8" => :mojave
    sha256 "27c9235025750addbd345949d2d743dcf0b689fb0a1922206badb576083af292" => :high_sierra
    sha256 "ab22e990d77643aeccd5c9965708a4b6aa57a296e810e4c06e0ae2983a8786e2" => :sierra
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
