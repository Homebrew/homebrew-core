class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-13.5.0/flyway-commandline-13.5.0.tar.gz"
  sha256 "5ec30849dc4ef9fc0883e50899cd5846b25aedcfe5fbca5ab6a791f901fe6ced"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1867e2b62f73f8ce130ba79540ad50118431adb6b99ab6ce0eecb63e10b3dd07"
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
