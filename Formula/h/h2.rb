class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.2.224/h2-2023-09-17.zip"
  version "2.2.224"
  sha256 "33f6c5c51aef2d9b15635214e4c7f01f82256f37df511b3efee3f6b6d79d5deb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5014a6205025e5b89e5aca2cecce9f2d6c2b5134821197e9ccc5205d1f417c0"
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
