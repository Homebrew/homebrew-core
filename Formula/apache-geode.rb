class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.13.3/apache-geode-1.13.3.tgz"
  mirror "https://archive.apache.org/dist/geode/1.13.3/apache-geode-1.13.3.tgz"
  mirror "https://downloads.apache.org/geode/1.13.3/apache-geode-1.13.3.tgz"
  sha256 "c725d01336b94e4c47a921825aa1616872754def202ee1c72074156c3a3848d1"
  license "Apache-2.0"

  depends_on "openjdk@11"

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.java_home_env("11")
  end

  test do
    flags = "--dir #{testpath} --name=geode_locator_brew_test"
    output = shell_output("#{bin}/gfsh start locator #{flags}")
    assert_match "Cluster configuration service is up and running", output
  ensure
    quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
  end
end
