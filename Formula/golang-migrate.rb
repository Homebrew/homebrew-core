class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.9.1.tar.gz"
  sha256 "6be8806c9e7cc95dea74560292061735642aad45de5de2ebc7e83ae789850655"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d38f404fd6ad213c520755055aa6fa4ec1639855ff1f3077761e7ef18d5d8d2" => :catalina
    sha256 "6c5c696c09ed9c3673a8e2b4ae21d35f9de975a8707936cc09d78dec66b0be7d" => :mojave
    sha256 "94091ebc44dcf5c7ca69ebe093fed133342fae074fa9e0061f464ccdf7605494" => :high_sierra
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
