class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.0.204/h2-2021-12-21.zip"
  version "2.0.204"
  sha256 "db56ce651133856ff471bae8d1eeb93937d50b4b8d78d70dc4a4eb8c8fcf5e04"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de2473255b0ce9d5570314b0d733482af275dd5119d46c91c59e51c32aa594a8"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

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
