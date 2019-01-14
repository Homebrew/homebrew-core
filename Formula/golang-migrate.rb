class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.2.1.tar.gz"
  sha256 "304adf11736d0948d29cf8d8840ea1e489cad33648fca368de00b2f051e73e9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7340ff1ca29d910ab17c555e96214b49b3910377e98d11c1643d774392875cc" => :mojave
    sha256 "8925ffc0a34381d864c67d985c847fb2fabdb03f927849b1cd011598e49f721d" => :high_sierra
    sha256 "368a25c3a31be3c167fbe71bf9d8e2ddb5732c6d88e558e2c678f6c21e622aaa" => :sierra
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
