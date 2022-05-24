class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://git.code.sf.net/p/launch4j/git.git",
      tag:      "Release_launch4j-3_14",
      revision: "46db737fd1885203fb098f4368cd5cf5c6792373"
  license all_of: ["BSD-3-Clause", "MIT"]
  revision 1

  livecheck do
    url :stable
    regex(/^(?:Release_launch4j[._-])?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "10fe31dd5081fecb626537d801e678e8921c5f8d655f7daee5e6c8dd2e2ef619"
    sha256 cellar: :any_skip_relocation, big_sur:  "4c6bfb289d9aeca25dbc25ff2f9fe12a49a635bf720fe54b788d4796c25bc108"
    sha256 cellar: :any_skip_relocation, catalina: "beffc91a157d5958d257adb6844cdde8fa2d375083e58aa89c5db2dbb9fd37c0"
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
