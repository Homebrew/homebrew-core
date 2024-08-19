class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/11.0.22/jetty-runner-11.0.22.jar"
  sha256 "0eca610f8fc7d1fb1a1fdf1235c5e10df9f7e9b028d058e1343e3c31062fb371"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+(?:[._-]v?\d+)?)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73e870a530ee72131d8289ee947c715cccc3be1d7ce6c731106ef554e2d98451"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73e870a530ee72131d8289ee947c715cccc3be1d7ce6c731106ef554e2d98451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73e870a530ee72131d8289ee947c715cccc3be1d7ce6c731106ef554e2d98451"
    sha256 cellar: :any_skip_relocation, sonoma:         "73e870a530ee72131d8289ee947c715cccc3be1d7ce6c731106ef554e2d98451"
    sha256 cellar: :any_skip_relocation, ventura:        "73e870a530ee72131d8289ee947c715cccc3be1d7ce6c731106ef554e2d98451"
    sha256 cellar: :any_skip_relocation, monterey:       "73e870a530ee72131d8289ee947c715cccc3be1d7ce6c731106ef554e2d98451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e613ec3d4ade529fde790ea149de19261cc96ea574597d620a146affbdae76"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"jetty-runner-#{version}.jar", "jetty-runner"
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    touch "#{testpath}/test.war"

    port = free_port
    pid = fork do
      exec "#{bin}/jetty-runner --port #{port} test.war"
    end
    sleep 10

    begin
      output = shell_output("curl -I http://localhost:#{port}")
      assert_match %r{HTTP/1\.1 200 OK}, output
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
