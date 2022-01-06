class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.0.206/h2-2022-01-04.zip"
  version "2.0.206"
  sha256 "3306748f1ba3e00b415bb6b50a9d61fd0026d6e55396940eb60c1d7c49947b6f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9b32a9438eb4f97cf37a52b395dc36b35edb94416d955adc0e64d996eae59b3"
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
