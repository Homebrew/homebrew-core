class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/7.13.0/flyway-commandline-7.13.0.tar.gz"
  sha256 "ad9515c6cc0974214ac2e5e5ce4a3eb7e64ed69951807d95719149e64922336b"
  license "Apache-2.0"

  livecheck do
    url "https://flywaydb.org/documentation/usage/maven/"
    regex(/&lt;version&gt;.*?v?(\d+(?:\.\d+)+)&lt;/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c5b9d0b2850549a2e30d0b60265cb50f3d1922a89947651dd6d4a8304a19c63"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
