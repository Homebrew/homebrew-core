class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/6.4.0/flyway-commandline-6.4.0.tar.gz"
  sha256 "784a2bc15a888195e68f1f3bfce97f9fed19c5c8858f9580b939dc9596232d0c"

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
