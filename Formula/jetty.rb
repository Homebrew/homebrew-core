class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.44.v20210927/jetty-distribution-9.4.44.v20210927.tar.gz"
  version "9.4.44.v20210927"
  sha256 "fdfd0d1e2732576c09246df8484ff7ed4aa4c84143927936934cb6b8e5194fa3"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a6be10513ab590b3a3eb6ae631a5480af414a2347dcd194530105f0263d6b967"
    sha256 cellar: :any, monterey:      "e2d53532f1b42e4722773be37c4f871fc4d4312ed3309764bc0b204f2fc15283"
    sha256 cellar: :any, big_sur:       "e8777d929a1655066acee7b4467241db035911c971da87619bb2df7b68db4b57"
    sha256 cellar: :any, catalina:      "e8777d929a1655066acee7b4467241db035911c971da87619bb2df7b68db4b57"
    sha256 cellar: :any, mojave:        "e8777d929a1655066acee7b4467241db035911c971da87619bb2df7b68db4b57"
  end

  # Ships a pre-built x86_64-only `libsetuid-osx.so`.
  depends_on arch: :x86_64
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
