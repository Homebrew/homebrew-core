class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.8.0.tar.gz"
  sha256 "c385d168e1deb56a147119545cd153f87007bdfe693585d4d181fa3d21368fc7"

  bottle do
    cellar :any_skip_relocation
    sha256 "0183fbf7e7763c8d89381409940796be65214865eae9cf6bf28e14b6c4b780a2" => :catalina
    sha256 "2d392c15f6fcd902987b0adea3afaaac86613fddc309763801c127b7ca13090f" => :mojave
    sha256 "eb39d2714f2994dca7d0812f40fc3718b46e6f1c7e8e0c8ad65d9e9ea4d60726" => :high_sierra
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
