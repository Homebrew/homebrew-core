class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/2.0.1/orc-tools-2.0.1-uber.jar"
  sha256 "7e58aee64a531f3f22aeac0c16037b1965bd282b0ee68bd2d310cdb484da5461"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9b07c22548e70fa2f9d41569909ad0616117efe6e2f9345843e97ab52be3de6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a35bdecc2b37467a1dcd06920730cd4f51b1cfd0a771db1386a899e183ab8d04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e91b1e8e34d21643bd341f65cd5118400a8d5bc59687711f4968c5f83650ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "1edc465ca38c8f9613c8b43db03a741de8ba4973c1d5d3efb1202441215ae848"
    sha256 cellar: :any_skip_relocation, ventura:        "8ac41d97b85a5bbbbf90c794cf8b0368b7618ffc7c9218309c81e552e9f0d04e"
    sha256 cellar: :any_skip_relocation, monterey:       "0c2c3778d4d6ad01863c8b957425b722f0ac4f33fa9403c45b371f28e8eea6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae202cc972ab42ec26b9d83174aaf643198f06c727914e9b8ae6c55d78ec7afc"
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
