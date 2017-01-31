class Modulo < Formula
  desc "source-only dependency manager"
  homepage "https://github.com/modulo-dm/modulo"
  url "https://github.com/modulo-dm/modulo/archive/v0.5.0.tar.gz"
  sha256 "d9d6362b962a5e747c785b56dc8084453870d260a83a3af8886dce678623c331"

  bottle do
    cellar :any_skip_relocation
    sha256 "b885b0927389818fc6cf186217eec981b8f2d18ae682333b7d708f6a0356b84f" => :sierra
    sha256 "c2049122beebd7eadaa49dbd7e14612d1e6b2a07919a2f82cde1021028cb0c61" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    xcodebuild "build", "-project", "modulo.xcodeproj", "-scheme", "modulo", "-configuration", "Release", "SYMROOT=build"
    bin.install "/tmp/modulo"
    man1.install "Documentation/modulo.1"
    man1.install "Documentation/modulo-layout.1"
    man1.install "Documentation/modulo-init.1"
    man1.install "Documentation/modulo-add.1"
    man1.install "Documentation/modulo-update.1"
  end

  test do
    system "#{bin}/modulo", "--help"
  end
end
