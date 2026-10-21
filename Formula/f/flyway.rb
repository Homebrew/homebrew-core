class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-13.10.3/flyway-commandline-13.10.3.tar.gz"
  sha256 "ba7c2f477b2e906526754e5479f59bce7ab999a524a4912bc5e930701774a201"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1c14ddfd6bbb6ac9f6c68806be1ad92ae517bafa0d4d4a7d833dce4aaa768f0"
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
