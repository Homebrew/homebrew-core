class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.1.0.tar.gz"
  sha256 "3297c98b3bbf5130425b1b2cfb17443a356248a985b57cee24eb9bb0612e500e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eaa8aed9d4a5a2adef82f74f9098bc4a6f74392ad43a001162baa5088655e64" => :mojave
    sha256 "ff9a64ae6bddcc6e133989ee342c1dd7add806a9464dbd1ec0714cab58ac3b0f" => :high_sierra
    sha256 "18dc965e30fc9a880f23ff04ef7690f0916859bfd327532a8fc6bbd766d1703b" => :sierra
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
