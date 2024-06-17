class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse-jdtls/eclipse.jdt.ls"
  url "https://download.eclipse.org/jdtls/milestones/1.36.0/jdt-language-server-1.36.0-202405301306.tar.gz"
  version "1.36.0"
  sha256 "028e274d06f4a61cad4ffd56f89ef414a8f65613c6d05d9467651b7fb03dae7b"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f796f725e4a2ba11182e5e7940f063940829a78a2f65424d08191b23a122a46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f796f725e4a2ba11182e5e7940f063940829a78a2f65424d08191b23a122a46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f796f725e4a2ba11182e5e7940f063940829a78a2f65424d08191b23a122a46"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f796f725e4a2ba11182e5e7940f063940829a78a2f65424d08191b23a122a46"
    sha256 cellar: :any_skip_relocation, ventura:        "0f796f725e4a2ba11182e5e7940f063940829a78a2f65424d08191b23a122a46"
    sha256 cellar: :any_skip_relocation, monterey:       "0f796f725e4a2ba11182e5e7940f063940829a78a2f65424d08191b23a122a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79d15be5e79f35aa5257ca2a56aeac54ec629098a3fca9c69068581bb0666d4c"
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
