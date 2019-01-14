class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=geode/1.8.0/apache-geode-1.8.0.tgz"
  sha256 "58edc41edac4eabd899322b73a24727eac41f6253274c2ce7d0a82227121ae3e"

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
      flags = "--dir #{testpath} --name=geode_locator_brew_test"
      output = shell_output("#{bin}/gfsh start locator #{flags}")
      assert_match "Cluster configuration service is up and running", output
    ensure
      quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
    end
  end
end
