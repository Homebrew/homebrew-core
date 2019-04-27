class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.3.1.tar.gz"
  sha256 "55b98e82871a32cac4eb1e2558a9f31e909ea98581c38dce0ceaff05d58bf2c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8229cc3ab4342b1a2d3e3fc817ccff9539531561d8266a03aa37e7597558ff31" => :mojave
    sha256 "454f7ab2efb834abcd33aa91d11a4abbf79497c533247af157f89dcdede35612" => :high_sierra
    sha256 "f382dd8b854a1bb907ee27cd7ecca0fd0b60cb0944c44fb701bfb483270f2133" => :sierra
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
