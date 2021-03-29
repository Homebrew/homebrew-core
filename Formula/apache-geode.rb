class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.13.2/apache-geode-1.13.2.tgz"
  mirror "https://archive.apache.org/dist/geode/1.13.2/apache-geode-1.13.2.tgz"
  mirror "https://downloads.apache.org/geode/1.13.2/apache-geode-1.13.2.tgz"
  sha256 "bc2d2e9bcec8f2fdfa2419894962314a3e3569fa617c3e2f6beca8097197ad02"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk@8"

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
