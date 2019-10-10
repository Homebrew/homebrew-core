class FlywayAT5 < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/5.2.4/flyway-commandline-5.2.4-macosx-x64.tar.gz"
  sha256 "3122916f45c95b2afd20b81126cbf687d1142e13e93d7434a06da642b99e2c4c"

  bottle :unneeded

  keg_only :versioned_formula

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
