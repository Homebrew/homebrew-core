class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://www.h2database.com/h2-2019-10-14.zip"
  version "1.4.200"
  sha256 "a72f319f1b5347a6ee9eba42718e69e2ae41e2f846b3475f9292f1e3beb59b01"
  license "MPL-2.0"

  livecheck do
    url "https://github.com/h2database/h2database.git"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "95b75dbd44a9a1ed9ca0279e66b7993282b0a6161539de582042dcc806b9f2c7"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # As of 1.4.190, the script contains \r\n line endings,
    # causing it to fail on macOS. This is a workaround until
    # upstream publishes a fix.
    #
    # https://github.com/h2database/h2database/issues/218
    h2_script = File.read("bin/h2.sh").gsub("\r\n", "\n")
    File.open("bin/h2.sh", "w") { |f| f.write h2_script }

    # Fix the permissions on the script
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
