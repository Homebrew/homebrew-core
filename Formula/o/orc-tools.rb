class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.9.1/orc-tools-1.9.1-uber.jar"
  sha256 "bd4b799b3a69506fcd11e2fac3219a215fff0bd6a467edef8bb7a7732f5abd5a"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, ventura:        "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, monterey:       "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, big_sur:        "79b2bb4ecd0d9d21f8b809399e1b2ca9fa414c8664f4bdb2586a166123867431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "226350e7cec7f6c8cb87a7e6ea6d6501a0cd2c68ed52eac7361b1acd670218c9"
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
