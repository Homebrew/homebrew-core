class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.3.v20170317/jetty-runner-9.4.3.v20170317.jar"
  version "9.4.3.v20170317"
  sha256 "e4dddfbb313ec115d10faf6b93971ae929f319d366ab3548e5d21be29cd41fbf"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]

    bin.mkpath
    bin.write_jar_script libexec/"jetty-runner-#{version}.jar", "jetty-runner"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jetty-runner --version", 1)
  end
end
