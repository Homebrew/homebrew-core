class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.18.0/flyway-commandline-11.18.0.tar.gz"
  sha256 "14c0423feef9ffb1d91b50d575d77873d5f36b3de828efc0ce4e477a3b782c10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63b94fb2e67d3c54da05d3898615e07398f6d0e6d5e6240cb6c80a885d6b2024"
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
