class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.13/launch4j-3.13-macosx-x86.tgz"
  version "3.13"
  sha256 "df232427bd5a4d1674e2e66232127954d18de21d10417ee8e11534d9a914bd0d"
  license all_of: ["BSD-3-Clause", "MIT"]

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end

  test do
    system "#{bin}/launch4j", "--version"
  end
end
