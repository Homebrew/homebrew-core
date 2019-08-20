class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.6.0.tar.gz"
  sha256 "ffb8e19e44b03e0d643aa99b4a1bd0f7b30d83c3973653c22610ba276a297737"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f661f286de8453030b9afb0ef6b481c98fa7c3e1dc61fed0563b9e308150467" => :mojave
    sha256 "bfb093f1442b2083c5d6476ca6f105a2992e8930721dfd82c2615514c19cf257" => :high_sierra
    sha256 "7cb1dbd4510ad05841124a713b05af66087056e00610b1d45666edb98a63ca35" => :sierra
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
