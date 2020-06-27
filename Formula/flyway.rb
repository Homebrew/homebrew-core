class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/6.5.0/flyway-commandline-6.5.0.tar.gz"
  sha256 "c9b02f2fb70c7ebc32f0e1620e633aeab90ded2e9fe6c829e67c1f327e474f61"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
