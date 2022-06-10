class Jdtls < Formula
  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse/eclipse.jdt.ls"
  url "https://download.eclipse.org/jdtls/milestones/1.12.0/jdt-language-server-1.12.0-202206011637.tar.gz"
  version "1.12.0"
  sha256 "38f20fec27a8fcdb1b3c49a117629dd0800b161171afd4b894bdc026f2fca2f3"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9beda534a10281a2fa57c7956968d6b9dac773c48bae07883925c7bd7bc935f6"
  end

  depends_on "openjdk@11"
  depends_on "python@3.9"

  def install
    libexec.install "bin"
    libexec.install "config_mac"
    libexec.install "config_linux"
    libexec.install "features"
    libexec.install "plugins"

    (bin/"jdtls").write_env_script libexec/"bin/jdtls",
      Language::Java.overridable_java_home_env("11")
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
