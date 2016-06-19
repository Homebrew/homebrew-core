class Luyten < Formula
  desc "Java decompiler GUI for Procyon"
  homepage "https://deathmarine.github.io/Luyten/"
  url "https://github.com/deathmarine/Luyten/releases/download/v0.4.7/luyten-0.4.7.jar", :using => :nounzip
  sha256 "7bd890b470b863bab48f941c21528a71488fd6f50fbf8e9ad7431ea02df5431c"

  head do
    url "https://github.com/deathmarine/Luyten.git"
    depends_on "maven" => :build
  end

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    if build.head?
      ENV.java_cache

      ver = `mvn org.apache.maven.plugins:maven-help-plugin:evaluate -Dexpression=project.version`.split.grep(/^\d+\.\d+\.\d+/).uniq.first
      system "mvn", "clean", "package"
      libexec.install "target/luyten-#{ver}.jar"
    else
      ver = version.to_s
      libexec.install "luyten-#{ver}.jar"
    end
    bin.write_jar_script libexec/"luyten-#{ver}.jar", "luyten"
  end

  test do
    io = IO.popen("luyten")
    sleep 5
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    io.read !~ /Exception/
  end
end
