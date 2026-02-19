class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.0.1/flyway-commandline-12.0.1.tar.gz"
  sha256 "57625a5dc862e5e3ceb364ab66b8dc4d569686a709eef8f924c4f4698b240b49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "352c5f407766f78e3e1c7ab595176b5414bd81a1026a50c6e223af95087e6484"
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
