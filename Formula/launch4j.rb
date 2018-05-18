class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.12/launch4j-3.12-macosx-x86.tgz"
  version "3.12"
  sha256 "754e557036ff4a469b4a24443c809113f85b9a0689a5ffdcf35a8a6e986c458f"

  bottle :unneeded

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end

  test do
    system "#{bin}/launch4j", "--version"
  end
end
