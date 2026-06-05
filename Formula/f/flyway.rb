class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.8.1/flyway-commandline-12.8.1.tar.gz"
  sha256 "7092f20453384355acbc1ed83f4b82b7f2232caed3d9bdf6e88bc55bb78f5440"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "209c4b4821db8ada8c4d7cde3fa35bffd68ae9ee93d91691480bf54db3270c26"
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
