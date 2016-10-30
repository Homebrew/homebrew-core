class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "http://launch4j.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.9/launch4j-3.9-macosx-x86.tgz"
  version "3.9"
  sha256 "5de7594b877827be169d88111f6d184db334871c88c2314cd70cc33c3c7344e1"

  bottle :unneeded

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end
end
