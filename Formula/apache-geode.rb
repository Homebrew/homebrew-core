class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.12.0/apache-geode-1.12.0.tgz"
  mirror "https://archive.apache.org/dist/geode/1.12.0/apache-geode-1.12.0.tgz"
  mirror "https://www.apache.org/dist/geode/1.12.0/apache-geode-1.12.0.tgz"
  sha256 "063b473dac914aca53c09326487cc96c63ef84eecc8b053c8cc3d5110e82f179"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.java_home_env("1.8")
  end

  test do
    flags = "--dir #{testpath} --name=geode_locator_brew_test"
    output = shell_output("#{bin}/gfsh start locator #{flags}")
    assert_match "Cluster configuration service is up and running", output
  ensure
    quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
  end
end
