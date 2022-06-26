class Derby < Formula
  desc "Apache Derby is an embedded relational database running on JVM"
  homepage "https://db.apache.org/derby/"
  url "https://www.apache.org/dyn/closer.lua?path=db/derby/db-derby-10.16.1.1/db-derby-10.16.1.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/db/derby/db-derby-10.16.1.1/db-derby-10.16.1.1-bin.tar.gz"
  sha256 "37aef8dca42061d5867afb2009c8d7a80e68c16e56aecaf088f3e30e470d9ef6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de4f510a364389097c3be710ab140928daff7078ac8d7d2757c42d20be07cf2e"
  end

  depends_on "openjdk@17"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install %w[lib test index.html LICENSE NOTICE RELEASE-NOTES.html
                       KEYS docs javadoc demo]
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin",
                             JAVA_HOME:     Language::Java.overridable_java_home_env("17")[:JAVA_HOME],
                             DERBY_INSTALL: libexec,
                             DERBY_HOME:    libexec
  end

  def post_install
    (var/"derby").mkpath
  end

  plist_options manual: "DERBY_OPTS=-Dsystem.derby.home=#{HOMEBREW_PREFIX}/var/derby #{HOMEBREW_PREFIX}/bin/startNetworkServer"

  service do
    run [opt_bin/"NetworkServerControl", "-h", "127.0.0.1", "start"]
    keep_alive true
    working_dir var/"derby"
  end

  test do
    assert_match "libexec/lib/derby.jar] #{version}",
                 shell_output("#{bin}/sysinfo")

    pid = fork do
      exec "#{bin}/startNetworkServer"
    end

    begin
      sleep 12
      exec "#{bin}/stopNetworkServer"
    ensure
      Process.wait(pid)
    end
  end
end
