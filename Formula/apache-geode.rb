class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.15.0/apache-geode-1.15.0.tgz"
  mirror "https://archive.apache.org/dist/geode/1.15.0/apache-geode-1.15.0.tgz"
  mirror "https://downloads.apache.org/geode/1.15.0/apache-geode-1.15.0.tgz"
  sha256 "97cd96e94991cbd433d93e8474e1c2e65deb92f022d810a1931464017701701b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7510007a9d6daa6387ddc637bd115e71511f5bc482b7340af4de0996b0312b47"
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
