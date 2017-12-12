class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/5.0.2/flyway-commandline-5.0.2-macosx-x64.tar.gz"
  sha256 "acda5a1d1b04b8e58969feb85bd4eed7d830099c057337b92d481b16a7f17fe2"

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
