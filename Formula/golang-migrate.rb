class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.0.0.tar.gz"
  sha256 "b6552d1450990fcbece1253b988e1a5ea8390d8686ce3bdfd52a0f7fbc1ad779"

  bottle do
    cellar :any_skip_relocation
    sha256 "02ed18f380c214fd87ebb83abb6f0bc4093ee568dfccb25cd257fe3519b0d7ba" => :mojave
    sha256 "811f53a8aa43f057526a018718fea09f6c4227ebc1c20e0ef8f271d68e08b60c" => :high_sierra
    sha256 "ad5e40bbaa24391e1f05b8d81e923349f3d9681d8974ecda4422428ae9a065ec" => :sierra
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
