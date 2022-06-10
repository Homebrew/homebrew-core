class Cnosdb < Formula
  desc "Open source distributed time series database"
  homepage "https://www.cnosdb.com"
  url "https://github.com/cnosdb/cnosdb/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "ae412d0944b64c9b39dc1edc66f7b6f712b85bc5afad354c12b135ae71017100"
  license "MIT"
  head "https://github.com/cnosdb/cnosdb.git"

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath
    system "go", "install", "./..."
    bin.install %w[cnosdb-cli cnosdb-ctl cnosdb-meta cnosdb-inspect cnosdb-tools]
  end

  test do
    system "#{bin}/cnosdb-cli"
  end
end
