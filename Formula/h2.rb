class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.1.212/h2-2022-04-09.zip"
  version "2.1.212"
  sha256 "013cc5765d1033edc8e792024aed7d91b169a7f3b2c52c6dc78a866a0a761f57"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b346d3fc7670e5ab942ff0cf9a7374ab421cade3c28875a893a2890fb70fa79f"
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
