class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.6.1.tar.gz"
  sha256 "934e10f6dd6c4b27a2aa561bdd4343afef1450ab34657a25aa702b0eab24085c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b44c220f57f18d8c36810b5564dfc00b249834fd2556d32fc4e418dbb4c0ca6" => :mojave
    sha256 "7b8c8206b4e0b1125c4fdcaa2b49c3dffb9aa1df79eb53be61ee49ebf5aed0fb" => :high_sierra
    sha256 "4735974f1742bffd40f8d7e541c41935f51dbf971b80c8e5d3eb4aef4a044d94" => :sierra
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
