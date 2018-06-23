class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=geode/1.6.0/apache-geode-1.6.0.tgz"
  sha256 "79e8d81d058b1c4edd5fb414ff30ac530f7913b978f5abc899c353fcb06e5ef3"

  bottle :unneeded

  # Geode does not work with Java 1.9 (see https://issues.apache.org/jira/browse/GEODE-3)
  depends_on :java => "1.8"

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.java_home_env("1.8")
  end

  test do
    begin
      output = shell_output("#{bin}/gfsh start locator --dir #{testpath} --name=geode_locator_brew_test")
      assert_match /Cluster configuration service is up and running/, output
    ensure
      quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
    end
  end
end
