class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=geode/1.9.1/apache-geode-1.9.1.tgz"
  mirror "https://archive.apache.org/dist/geode/1.9.1/apache-geode-1.9.1.tgz"
  sha256 "4243c1361fc7dec3f77801ec164b43c2fcda8526972516033e1dec5b0b2d544d"

  bottle :unneeded

  # Geode should not be compiled on Java 9+ yet (see https://issues.apache.org/jira/browse/GEODE-3)
  depends_on :java => "1.8"

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.java_home_env("1.8")
  end

  test do
    begin
      flags = "--dir #{testpath} --name=geode_locator_brew_test"
      output = shell_output("#{bin}/gfsh start locator #{flags}")
      assert_match "Cluster configuration service is up and running", output
    ensure
      quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
    end
  end
end
