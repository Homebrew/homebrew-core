class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://git.code.sf.net/p/launch4j/git.git",
      tag:      "Release_launch4j-3_14",
      revision: "46db737fd1885203fb098f4368cd5cf5c6792373"
  license all_of: ["BSD-3-Clause", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b35bb3862964983d4993c79741d8b85d8accf264f7a281af53d2626c64235e3d"
  end

  depends_on "ant" => :build
  depends_on arch: :x86_64
  # Installs a pre-built `ld` and `windres` file with linkage to zlib
  depends_on :macos
  depends_on "openjdk"

  def install
    system "ant", "compile"
    system "ant", "jar"
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end

  test do
    system "#{bin}/launch4j", "--version"
  end
end
