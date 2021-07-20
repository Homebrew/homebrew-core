class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/7.11.3/flyway-commandline-7.11.3.tar.gz"
  sha256 "1b792702b0d64c8a800161710accdcfc2dfa8a2da591776a919b9c1d7b9e83fb"
  license "Apache-2.0"

  livecheck do
    url "https://flywaydb.org/documentation/usage/maven/"
    regex(/&lt;version&gt;.*?v?(\d+(?:\.\d+)+)&lt;/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7f00af7508b36cbe28e8ff882b70649f8afcc6d1671bf11edb5e7e1d05570a30"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
