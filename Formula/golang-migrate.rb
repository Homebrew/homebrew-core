class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.10.0.tar.gz"
  sha256 "ff55f958b869a94cfa892e61195e97def0d8cad2404963f0ce2dfadaa406bb42"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c123be8ebd6c27ec7dd405ef4430d51a0200aebff16aa3a7b85ce2ebce4cd3c" => :catalina
    sha256 "15a02a1b2534b3078ece9ef5197cd822688154ccc74288fde0770ccebbd8608f" => :mojave
    sha256 "d154952644c694027e3931fba144201db04fee996a59f32982b5dfddb37fa1ab" => :high_sierra
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
