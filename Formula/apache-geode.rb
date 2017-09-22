class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=geode/1.2.1/apache-geode-1.2.1.tar.gz"
  sha256 "c5d268e286ca450ef0640b77429f7e65e100ffe1d3e882d2c9401a4f4d3a8a54"

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
