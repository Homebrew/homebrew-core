class Monax < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/monax/monax/archive/v0.18.0.tar.gz"
  sha256 "8ad3166e3ca76738c6542bd8b85dcef1643b68a3755abe3e0a7f3c9cdd027afb"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a0e02b31db9fefff086d39569441d011207efc785a3132815f536d55a465066c" => :high_sierra
    sha256 "2e2c0dea3325686ce0fe3f70ec622e32e86b2272be1bc4340183462d72109bdc" => :sierra
    sha256 "822ea5de0bc5eff7e59ede28153ecd89a87bd14b10cf8caab5d874c714c6e1b0" => :el_capitan
    sha256 "728c8ec80a25720bd76459cd1d1da6a4decf669327db98330b7932d0de6f8136" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker"
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/monax").mkpath
    ln_sf buildpath, buildpath/"src/github.com/monax/monax"
    system "go", "install", "github.com/monax/monax/cmd/monax"
  end

  test do
    system "#{bin}/monax", "version"
  end
end
