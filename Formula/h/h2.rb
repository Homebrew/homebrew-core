class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.5.252/h2-2026-09-23.zip"
  version "2.5.252"
  sha256 "e81c3cb2174a3a0aa4d7887dd0c8c5e307960e6f47925d8c40283f9bb960b13b"
  license "MPL-2.0"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c311538a50ec4b368318f006d38da2e05ebc07676cc48602afaff7e96563e52d"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    # Remove windows files
    rm(Dir["bin/*.bat"])

    # Fix the permissions on the script
    # upstream issue, https://github.com/h2database/h2database/issues/3254
    chmod 0755, "bin/h2.sh"

    libexec.install Dir["*"]
    (bin/"h2").write_env_script libexec/"bin/h2.sh", Language::Java.overridable_java_home_env
  end

  service do
    run [opt_bin/"h2", "-tcp", "-web", "-pg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "Usage: java org.h2.tools.GUIConsole", shell_output("#{bin}/h2 -help 2>&1")
  end
end
