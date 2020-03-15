class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.10.0.tar.gz"
  sha256 "ff55f958b869a94cfa892e61195e97def0d8cad2404963f0ce2dfadaa406bb42"

  bottle do
    cellar :any_skip_relocation
    sha256 "69455cf25056fe92de684dbb7cc1e6e5ed40ce5ba283975b8a6cd0b71c54a6f0" => :catalina
    sha256 "932ad427c9d30c2fe5703ee1b5a303935ce67b7707ca2670dfe086a822c691f5" => :mojave
    sha256 "128dae78f429722aec6b3d537357ccc31fb36ba88bf986e8a6ef3d880de09390" => :high_sierra
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
