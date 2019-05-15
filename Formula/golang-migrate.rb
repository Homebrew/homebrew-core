class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.3.1.tar.gz"
  sha256 "55b98e82871a32cac4eb1e2558a9f31e909ea98581c38dce0ceaff05d58bf2c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "12db1f50eb2c84470b017f65b442194c2d44e348d70aaf955733eb78a8bbeb5d" => :mojave
    sha256 "bb29a878a4679707360247c863dd59a4be3d28284c92dd575bfcedf503250ece" => :high_sierra
    sha256 "d866f93abb4b459f3a4feee1cdb8da7cd0d693ac621d5d1edc5f69871065d44d" => :sierra
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
