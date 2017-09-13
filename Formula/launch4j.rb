class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.11/launch4j-3.11-macosx-x86.tgz"
  version "3.11"
  sha256 "add9e680f82f45b79f9c7e878fbde43aa333cefe3ae86bcdc85937c480b378fa"

  bottle :unneeded

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end
end
