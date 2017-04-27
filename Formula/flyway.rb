class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0.jar"
  sha256 "595a4331c3d141f414a8a21dd3d5a00df529fc67d73876e54144badb55d68498"

  bottle :unneeded

  depends_on :java

  def install
    rm Dir["*.cmd"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/flyway"]
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
