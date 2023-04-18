class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.15.1/apache-geode-1.15.1.tgz"
  mirror "https://archive.apache.org/dist/geode/1.15.1/apache-geode-1.15.1.tgz"
  mirror "https://downloads.apache.org/geode/1.15.1/apache-geode-1.15.1.tgz"
  sha256 "2668970982d373ef42cff5076e7073b03e82c8e2fcd7757d5799b2506e265d57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cf4c4a321ae1e5a768773e91021ee8d7d0c4555c2209e532b08efd26929d512"
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
