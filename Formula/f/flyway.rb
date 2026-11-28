class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-13.13.0/flyway-commandline-13.13.0.tar.gz"
  sha256 "59ff101f28ab92008db079c3b8321748cee42a0111d6b3156583fdadef2bd673"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "1d7b78786d1e9f63d0a5483726a296c4bad61a25c907acce9d53244fc89fc4bb"
    sha256 cellar: :any_skip_relocation, all: "3c772485bc2826b1c3f048c8408e10befec8ba091dedca337facb438111c2295"
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
