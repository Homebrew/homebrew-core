class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/6.5.5/flyway-commandline-6.5.5.tar.gz"
  sha256 "b6a5809ae91cc8acf9c11312967d732937d9ce3810584f729b54b354f3a3803c"
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
