class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/7.0.2/flyway-commandline-7.0.2.tar.gz"
  sha256 "c2d23dbed8ce8c6743fc2541dba1cbb22af5d7a72cf22b8534ecb1801b83faaf"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Get Started with Flyway\s+v?(\d+(?:\.\d+)+) </im)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
