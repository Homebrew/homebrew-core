class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.1.1/flyway-commandline-12.1.1.tar.gz"
  sha256 "cebae1ff5fbd9a25844d0ae937ee44621c0c7671a46267e23b729ac12717feee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "158728287bfba538e04eba488334953e65fb87b29928fc4aff332387be72be5d"
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
