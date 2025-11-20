class Derby < Formula
  desc "Apache Derby is an embedded relational database running on JVM"
  homepage "https://db.apache.org/derby/"
  url "https://www.apache.org/dyn/closer.lua?path=db/derby/db-derby-10.17.1.0/db-derby-10.17.1.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/db/derby/db-derby-10.17.1.0/db-derby-10.17.1.0-bin.tar.gz"
  sha256 "cbcfe4a0f07aab943cf89978f38d9047a9783233a770c54074bf555a65bedd42"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a4ec775f18dc3de32bd09a237f3ed1eba99aa4b137cf4eedb529232a03e85201"
  end

  depends_on "openjdk"

  def install
    env = Language::Java.java_home_env.merge(DERBY_INSTALL: libexec, DERBY_HOME: libexec)
    rm_r(Dir["bin/*.bat"])
    libexec.install %w[lib test index.html LICENSE NOTICE RELEASE-NOTES.html
                       KEYS docs javadoc demo]
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", env
    (var/"derby").mkpath
  end

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
