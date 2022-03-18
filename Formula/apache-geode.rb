class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.14.4/apache-geode-1.14.4.tgz"
  mirror "https://archive.apache.org/dist/geode/1.14.4/apache-geode-1.14.4.tgz"
  mirror "https://downloads.apache.org/geode/1.14.4/apache-geode-1.14.4.tgz"
  sha256 "7dd214f41d2bb1187efc83f054028e6f747a7d4ec7c417dcd003edbcd1e1f59b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65bea795d99a6dec2fb13936bfe830688745805d7799083bcd7223a5cfedf68f"
  end

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
