class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-13.7.0/flyway-commandline-13.7.0.tar.gz"
  sha256 "2b73bda15888765421101336cbfbd9d78a4e2d07e7090bd53f53ad319786e060"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4febe0b254f15320b1c504141fb77beee28f5ec40622aa05c3e5e29ff0eddc1"
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
