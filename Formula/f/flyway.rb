class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-13.3.0/flyway-commandline-13.3.0.tar.gz"
  sha256 "a68463f1bcb019ce1c46a283789c41ef33ca5d42aa1f02936e5650e4483ed476"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6deeb3880bced0e2b4360bb64456a5ec3fecb578684e74d6422fe99f7ad4114"
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
