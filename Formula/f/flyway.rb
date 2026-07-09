class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.10.0/flyway-commandline-12.10.0.tar.gz"
  sha256 "259d2a286a9a373343fa828c9ff990734481ccd531a48cd7e02f3a66797ff45a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ad36d9f7e882a1cfc584ef51ea9313d0b7972db62d2c5efb30a90ba890c8bf1"
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
