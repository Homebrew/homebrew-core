class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.13.1/flyway-commandline-11.13.1.tar.gz"
  sha256 "5701ac76e2cc6a292072bfde31dc6453a9101bb21761c64bd09b61809850af47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "468098928be6c216ce8a68d35ae17c864409a7231a89401e46590c4e32c06e43"
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
