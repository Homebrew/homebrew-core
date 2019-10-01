class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=geode/1.10.0/apache-geode-1.10.0.tgz"
  mirror "https://archive.apache.org/dist/geode/1.10.0/apache-geode-1.10.0.tgz"
  mirror "https://www.apache.org/dist/geode/1.10.0/apache-geode-1.10.0.tgz"
  sha256 "d13a7e91d11ce14cc7ad3c024b25e541343653b8ad2a88d461a59fec97d59655"

  bottle :unneeded

  depends_on :java => "1.8+"

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
