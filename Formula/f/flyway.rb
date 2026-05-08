class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.6.0/flyway-commandline-12.6.0.tar.gz"
  sha256 "3f905fe1db693a3164639eca0dcba97ba08bfb1576e90b96045c5addda8e2e42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47d55b49f06694d8a8e9ffde19647ea5164da162e133f66947f4d610a84653ea"
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
