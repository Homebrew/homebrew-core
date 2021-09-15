class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.43.v20210629/jetty-distribution-9.4.43.v20210629.tar.gz"
  version "9.4.43.v20210629"
  sha256 "01fae654b09932e446019aa859e7af6e05e27dbade12b54cd7bae3249fc723d9"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "02ca9582b60cb87f4a41e9498d10b5e8f2d0ad62cf801b2312ffead4ec6f58eb"
    sha256 cellar: :any, big_sur:       "48ad1144981f0fe4371ef1324e00e75dd0eabc5b595f38655d2a47de1cee4720"
    sha256 cellar: :any, catalina:      "48ad1144981f0fe4371ef1324e00e75dd0eabc5b595f38655d2a47de1cee4720"
    sha256 cellar: :any, mojave:        "48ad1144981f0fe4371ef1324e00e75dd0eabc5b595f38655d2a47de1cee4720"
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
