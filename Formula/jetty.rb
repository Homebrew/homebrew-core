class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.35.v20201120/jetty-distribution-9.4.35.v20201120.tar.gz"
  version "9.4.35.v20201120"
  sha256 "5b2d099a167e70628873db54af4ac6a16029909691408a8468ee446e3eceedb2"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (libexec/"logs").mkpath

    bin.mkpath
    Dir.glob("#{libexec}/bin/*.sh") do |f|
      scriptname = File.basename(f, ".sh")
      (bin/scriptname).write <<~EOS
        #!/bin/bash
        export JETTY_HOME='#{libexec}'
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        exec #{f} "$@"
      EOS
      chmod 0755, bin/scriptname
    end
  end

  test do
    ENV["JETTY_BASE"] = testpath
    cp_r Dir[libexec/"*"], testpath
    pid = fork { exec bin/"jetty", "start" }
    sleep 5 # grace time for server start
    begin
      assert_match /Jetty running pid=\d+/, shell_output("#{bin}/jetty check")
      assert_equal "Stopping Jetty: OK\n", shell_output("#{bin}/jetty stop")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
