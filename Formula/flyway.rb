class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/6.0.4/flyway-commandline-6.0.4.tar.gz"
  sha256 "47129b3b6ed0b6b77940bfba281f6f9ed83e90e5184f0801084ee03d98d91258"

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
