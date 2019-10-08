class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.6.2.tar.gz"
  sha256 "f7f07e240bc2d0afbcafc83f46eef0136ceb678ced4ece87ed619e901993c569"

  bottle do
    cellar :any_skip_relocation
    sha256 "20069ede947f7b223053acc87ea0274a4ac454ababb36d67f3d124c3f5054132" => :catalina
    sha256 "c1ae85a775502701537eb83a9d0dd99cb2631c288150a0be07ee473ab8e8d7dc" => :mojave
    sha256 "88db878600fa2e513341891e02dec3f53c00dff31ef93f5c0be3993f0ed09509" => :high_sierra
    sha256 "5a4df4044ef4e67a1aca08f13ee1afa43bf569f335a0a5609b6592648812c3ea" => :sierra
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
