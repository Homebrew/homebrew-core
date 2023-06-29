class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.9.0/orc-tools-1.9.0-uber.jar"
  sha256 "26d0f9635b02d2c31229001810d66cc5a92d63f4eb893e5bee9a686011cbf91c"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b44c722e1c6ed537aa34baba773f683c868e94f5463250402de25f6da1449e86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b44c722e1c6ed537aa34baba773f683c868e94f5463250402de25f6da1449e86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b44c722e1c6ed537aa34baba773f683c868e94f5463250402de25f6da1449e86"
    sha256 cellar: :any_skip_relocation, ventura:        "b44c722e1c6ed537aa34baba773f683c868e94f5463250402de25f6da1449e86"
    sha256 cellar: :any_skip_relocation, monterey:       "b44c722e1c6ed537aa34baba773f683c868e94f5463250402de25f6da1449e86"
    sha256 cellar: :any_skip_relocation, big_sur:        "b44c722e1c6ed537aa34baba773f683c868e94f5463250402de25f6da1449e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591da144e549d94d161b4467528dece496498289db007a2bd5974b74a98c0c7f"
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
