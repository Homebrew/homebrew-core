class Jdtls < Formula
  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse/eclipse.jdt.ls"
  url "https://download.eclipse.org/jdtls/milestones/1.10.0/jdt-language-server-1.10.0-202204131925.tar.gz"
  sha256 "b0faaf4ff8817cae607a6c2d54b78baad6306de3ab9104ff252b22eb33d82049"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cca45acde6eb4d63b7f91b70c010b9804809bcdb4efbe22f7c190e1e5c5fc11b"
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
