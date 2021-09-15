class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.14/launch4j-3.14-macosx-x86.tgz"
  version "3.14"
  sha256 "caed147c560551bcf46d1a894083808e58de62941b268ef58ca803ed09736675"
  license all_of: ["BSD-3-Clause", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b35bb3862964983d4993c79741d8b85d8accf264f7a281af53d2626c64235e3d"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end

  test do
    system "#{bin}/launch4j", "--version"
  end
end
