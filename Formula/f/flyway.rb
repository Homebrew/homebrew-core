class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.17.1/flyway-commandline-11.17.1.tar.gz"
  sha256 "fa33ed14a4f3828e8f03b037ebe475a0db8e4f80e4a99bf614972bf924481a8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "970389813b187a616798ec0b01a752775cb01f4270aa83c0afe6d7110535f08e"
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
