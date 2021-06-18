class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.42.v20210604/jetty-distribution-9.4.42.v20210604.tar.gz"
  version "9.4.42.v20210604"
  sha256 "c6182553e19dd6d40e043e38315a74be1b5e3f627ef367a3c8bc45cd199cc912"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "70a8d29158747ea3514ed7a27ad09242ef962d6242b640f57b9dfe2f846105e3"
    sha256 cellar: :any, big_sur:       "2575222cd99db83ae6f6ba936887898558cdeece5018cef7c757b09b0baa1ff0"
    sha256 cellar: :any, catalina:      "2575222cd99db83ae6f6ba936887898558cdeece5018cef7c757b09b0baa1ff0"
    sha256 cellar: :any, mojave:        "2575222cd99db83ae6f6ba936887898558cdeece5018cef7c757b09b0baa1ff0"
  end

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
    ENV["JETTY_ARGS"] = "jetty.http.port=#{free_port} jetty.ssl.port=#{free_port}"
    ENV["JETTY_BASE"] = testpath
    cp_r Dir[libexec/"*"], testpath
    pid = fork { exec bin/"jetty", "start" }
    sleep 5 # grace time for server start
    begin
      assert_match(/Jetty running pid=\d+/, shell_output("#{bin}/jetty check"))
      assert_equal "Stopping Jetty: OK\n", shell_output("#{bin}/jetty stop")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
