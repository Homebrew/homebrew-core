class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse/eclipse.jdt.ls"
  url "https://download.eclipse.org/jdtls/milestones/1.22.0/jdt-language-server-1.22.0-202304131553.tar.gz"
  version "1.22.0"
  sha256 "5fe2b9595379bb40354c91b9224eb172f2b4d7ce855c3294ab92e84d2c0bbf41"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "780bb1727f0cc0eeed344cdd15a81a788fecda09f802a80824ea6fa29e306464"
  end

  depends_on "openjdk"
  depends_on "python@3.11"

  def install
    libexec.install %w[bin config_mac config_linux features plugins]
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
