class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.6.1/flyway-commandline-12.6.1.tar.gz"
  sha256 "edfaf7770b8b028fe4fca904e72275904c20c4bc87550188b1cfaa4168e4fafc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3657463777e4c37b894dcc987bc3b39cf28b8690971dfcc29f590bbf501efb84"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flyway --version")

    assert_match "Successfully validated 0 migrations",
      shell_output("#{bin}/flyway -url=jdbc:h2:mem:flywaydb validate")
  end
end
