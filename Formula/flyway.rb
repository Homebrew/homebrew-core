class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/6.5.6/flyway-commandline-6.5.6.tar.gz"
  sha256 "7adc487a0f7007809b46ef6d65cedff504b2e27b5e7d588d0764403b584830b1"
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
