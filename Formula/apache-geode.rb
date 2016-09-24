class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=incubator/geode/1.0.0-incubating.M3/apache-geode-1.0.0-incubating.M3.tar.gz"
  version "1.0.0-incubating.M3"
  sha256 "294f4da36efd5c967c6dce94c719fbdaee4cca3ddcfcea4069bc44288f9b8eb4"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.java_home_env("1.8+")
  end

  test do
    ENV.java_cache
    begin
      output = shell_output("#{bin}/gfsh start locator --dir #{testpath} --name=geode_locator_brew_test")
      assert_match /Cluster configuration service is up and running/, output
    ensure
      quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
    end
  end
end
