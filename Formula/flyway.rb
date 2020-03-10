class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/6.3.0/flyway-commandline-6.3.0.tar.gz"
  sha256 "591288eedebc86d78cc5d7fe885bfe9af5dd77c75b91b64555fdde9299b11ea2"

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
