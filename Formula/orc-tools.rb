class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.7.0/orc-tools-1.7.0-uber.jar"
  sha256 "29d371b802b88fcc1c0f7e97a9d6dca26b04b9cbc797811630dd1031e0fc0e6f"
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
