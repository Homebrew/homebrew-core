class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.7.1/orc-tools-1.7.1-uber.jar"
  sha256 "53c7eae1399135227c89eecc5ec63d156bcaa753b8c1b4b69e30680e386f17a0"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a2afb894549011d634dc18b93f8e18c64dbf4a02177fa1347d29a8c9dc321e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a2afb894549011d634dc18b93f8e18c64dbf4a02177fa1347d29a8c9dc321e8"
    sha256 cellar: :any_skip_relocation, catalina:      "4a2afb894549011d634dc18b93f8e18c64dbf4a02177fa1347d29a8c9dc321e8"
    sha256 cellar: :any_skip_relocation, mojave:        "4a2afb894549011d634dc18b93f8e18c64dbf4a02177fa1347d29a8c9dc321e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650434bdaf880afab5b34cee38e36def2a8a29a01cb791428b35bcf20b7539ff"
    sha256 cellar: :any_skip_relocation, all:           "05f641694d0470d1996b47d59106cc34f1b97157bf3293919b70602bf2036903"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
