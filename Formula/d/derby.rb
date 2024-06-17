class Derby < Formula
  desc "Apache Derby is an embedded relational database running on JVM"
  homepage "https://db.apache.org/derby/"
  url "https://www.apache.org/dyn/closer.lua?path=db/derby/db-derby-10.17.1.0/db-derby-10.17.1.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/db/derby/db-derby-10.17.1.0/db-derby-10.17.1.0-bin.tar.gz"
  sha256 "cbcfe4a0f07aab943cf89978f38d9047a9783233a770c54074bf555a65bedd42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f79bc458b7cf34ad82213719c7f9262ac524ab51eb2c4c6804b088cb041c61f"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install %w[lib test index.html LICENSE NOTICE RELEASE-NOTES.html
                       KEYS docs javadoc demo]
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin",
                             JAVA_HOME:     Formula["openjdk"].opt_prefix,
                             DERBY_INSTALL: libexec,
                             DERBY_HOME:    libexec
  end

  def post_install
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
