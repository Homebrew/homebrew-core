class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.15.1/apache-geode-1.15.1.tgz"
  mirror "https://archive.apache.org/dist/geode/1.15.1/apache-geode-1.15.1.tgz"
  mirror "https://downloads.apache.org/geode/1.15.1/apache-geode-1.15.1.tgz"
  sha256 "2668970982d373ef42cff5076e7073b03e82c8e2fcd7757d5799b2506e265d57"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "36121f60a1dd6f9a614219b11e6f4d3e9fd91e76dc91af213b54af1cbeab0ae0"
  end

  depends_on "openjdk"

  def install
    rm("bin/gfsh.bat")
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    (bin/"gfsh").write_env_script libexec/"bin/gfsh", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/gfsh start locator --name=locator1")
    assert_match "Cluster configuration service is up and running", output

    output = shell_output("#{bin}/gfsh -e connect -e 'start server --name=server1 --server-port=#{free_port}'")
    assert_match "server1 is currently online", output

    output = shell_output("#{bin}/gfsh -e connect -e 'create region --name=regionA --type=REPLICATE_PERSISTENT'")
    assert_match 'Region "/regionA" created on "server1"', output

    output = shell_output("#{bin}/gfsh -e connect -e 'put --region=regionA --key=\"1\" --value=\"one\"'")
    assert_match(/Result\s*:\s*true/, output)

    output = shell_output("#{bin}/gfsh -e connect -e 'put --region=regionA --key=\"2\" --value=\"two\"'")
    assert_match(/Result\s*:\s*true/, output)

    output = shell_output("#{bin}/gfsh -e connect -e 'query --query=\"select * from /regionA\"'")
    assert_match <<~EOS, output
      Result
      ------
      two
      one
    EOS
  ensure
    system bin/"gfsh", "-e", "connect", "-e", "shutdown --include-locators=true"
  end
end
