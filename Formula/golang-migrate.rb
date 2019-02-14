class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.2.2.tar.gz"
  sha256 "611b0eb31f915d3e8d50f2744bd9080da9a82480d1c374f7da367e3454e818b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd7893fc3c44b1f910ecd649c4ac44cf12db2ce1f9987aef37eabbe27a2f418a" => :mojave
    sha256 "09d2d19328a2677a7add78f156916ae18c105967c2f484b88688859fb20d1fbe" => :high_sierra
    sha256 "2b3f40c091f3d30fef384985e27b3c7755f6a85e914e2f80ff7699a1a1c77f3f" => :sierra
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
