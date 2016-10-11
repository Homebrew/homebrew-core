class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/2.1.0.tar.gz"
  sha256 "a1ea624e913e258596ea6340c8818a90c21962b0a75cf005e49a0f72f2077b2e"
  head "https://github.com/prasmussen/gdrive.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "739ce50308d1f159b009ab60251c137f56aeccb1620a89972ef9b995daf1a757" => :sierra
    sha256 "4cb0399839f4d61561537a5e3e824fd4b158de9976fec00a3eaf5af2d75263a0" => :el_capitan
    sha256 "a735d01325571d987ef32720a536928faad92a692b2f9008a769b07c6dac5931" => :yosemite
    sha256 "cac347dada281fd7e1b31bd08b0fcf05f0cadfd2e16f603590505bd0f6592064" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prasmussen/"
    ln_sf buildpath, buildpath/"src/github.com/prasmussen/gdrive"
    system "go", "build", "-o", "gdrive", "."
    bin.install "gdrive"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
  end
end
