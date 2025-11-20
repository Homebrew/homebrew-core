class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/1.15.2/apache-geode-1.15.2.tgz"
  mirror "https://archive.apache.org/dist/geode/1.15.2/apache-geode-1.15.2.tgz"
  mirror "https://downloads.apache.org/geode/1.15.2/apache-geode-1.15.2.tgz"
  sha256 "60d190b07b4dabd83a86bfa21acab7ed38d2eccaabe4bc5baabab0981cf7910a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a0b8cb1ec42b12799db4b388cf1e82b3adcb43b92dd4be77ff331516bd9d1f7"
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
