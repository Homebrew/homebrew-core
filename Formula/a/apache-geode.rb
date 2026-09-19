class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=geode/2.0.3/apache-geode-2.0.3.tgz"
  mirror "https://archive.apache.org/dist/geode/2.0.3/apache-geode-2.0.3.tgz"
  mirror "https://downloads.apache.org/geode/2.0.3/apache-geode-2.0.3.tgz"
  sha256 "23dd1cbf5c6ed49909a596f0b49c0ec73f6f3c7e6fec20c07d32af3543684825"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e41164b7cec8d07f262d3b39cccc2910f73e7762973b0c3de300d9dc15600b94"
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
