class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-13.0.0/flyway-commandline-13.0.0.tar.gz"
  sha256 "b956ef8ef7c4c3e26a4e271f0773766be0b19ba7c9469b4e266e02f28675e5aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "825ab31336c2c1eeee2863c0cd26d6a02e49187b40d57d4958fa902859a6ff11"
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
