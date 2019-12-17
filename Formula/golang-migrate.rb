class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.7.1.tar.gz"
  sha256 "5f3b68a03e9fc6d4632a3e55be4679418b28fe1aec1a34c120ece019186068ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ef361616d08848b2586b20987e26800a37044db2461fc5af24baeae7370dc87" => :catalina
    sha256 "dcd6b82728a548628e7522b9a66c7a3db4fc1b840a5c606ba63b37b11b2d0d29" => :mojave
    sha256 "e261d53fc5a5049490e18ea809fdac6cb6898447ad21c319ca586ead90fb13e6" => :high_sierra
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
