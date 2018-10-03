class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.12.v20180830/jetty-distribution-9.4.12.v20180830.tar.gz"
  version "9.4.12.v20180830"
  sha256 "03c7b8cc5702b52173afad56b3c40e5e5dcf22cca23c1423b99486bb3b4389fc"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    (libexec+"logs").mkpath

    bin.mkpath
    Dir.glob("#{libexec}/bin/*.sh") do |f|
      scriptname = File.basename(f, ".sh")
      (bin+scriptname).write <<~EOS
        #!/bin/bash
        JETTY_HOME=#{libexec}
        #{f} "$@"
      EOS
      chmod 0755, bin+scriptname
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
