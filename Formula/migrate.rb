class Migrate < Formula
  desc "Database migrations. CLI and Golang library."
  homepage "https://github.com/mattes/migrate"
  url "https://github.com/mattes/migrate/releases/download/v3.0.1/migrate.darwin-amd64.tar.gz"
  version "3.0.1"
  sha256 "17e19678e930d4a48114937fb07300c107088d86a80c798630fabc08d32ee4ee"

  def install
    mv "migrate.darwin-amd64", "migrate"
    bin.install "migrate"
  end

  test do
    system "#{bin}/migrate", "-version"
  end
end
