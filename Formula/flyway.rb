class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/4.0.1/flyway-commandline-4.0.1.tar.gz"
  sha256 "d23d8e9a13d3f31b51385c8937adefc49b4b46bb61805b36026f8c26be5255d0"

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
