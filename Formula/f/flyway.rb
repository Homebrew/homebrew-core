class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-11.20.2/flyway-commandline-11.20.2.tar.gz"
  sha256 "441f5c19af8607bfb194ba315552f0823066fe3ff04cef63196989b32940997c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf717d69518bed50a83a335224bf5e89a070d193b40d249454343c9a1ef7272d"
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
