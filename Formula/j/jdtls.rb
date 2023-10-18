class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse-jdtls/eclipse.jdt.ls"
  url "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.28.0/jdt-language-server-1.28.0-202309281329.tar.gz"
  version "1.28.0"
  sha256 "b15c6badd1f437b533d857720d7593c1cbb6ee9afb4dfb0579b7318e3dbb2e19"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "91998a3e51a619b19546dbbf01abc594f8ed576d0b96f53e691fd669878bd696"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  def install
    libexec.install %w[
      bin features plugins
      config_mac config_mac_arm config_ss_mac config_ss_mac_arm
      config_linux config_linux_arm config_ss_linux config_ss_linux_arm
    ]
    rewrite_shebang detected_python_shebang, libexec/"bin/jdtls"
    (bin/"jdtls").write_env_script libexec/"bin/jdtls", Language::Java.overridable_java_home_env
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3("#{bin}/jdtls", "-configuration", "#{testpath}/config", "-data",
        "#{testpath}/data") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
