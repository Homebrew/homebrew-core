class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.7.2/orc-tools-1.7.2-uber.jar"
  sha256 "abaad645670eaf34592a76c7afc5f34ac1f85a559e3f77943f3f97608b194c51"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da7bcb0dec6b897b2a342966ad3ec5c69f307831fb1210281a559d99d22723b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da7bcb0dec6b897b2a342966ad3ec5c69f307831fb1210281a559d99d22723b1"
    sha256 cellar: :any_skip_relocation, monterey:       "da7bcb0dec6b897b2a342966ad3ec5c69f307831fb1210281a559d99d22723b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "da7bcb0dec6b897b2a342966ad3ec5c69f307831fb1210281a559d99d22723b1"
    sha256 cellar: :any_skip_relocation, catalina:       "da7bcb0dec6b897b2a342966ad3ec5c69f307831fb1210281a559d99d22723b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da7bcb0dec6b897b2a342966ad3ec5c69f307831fb1210281a559d99d22723b1"
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
