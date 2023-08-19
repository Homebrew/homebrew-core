class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse/eclipse.jdt.ls"
  url "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.26.0/jdt-language-server-1.26.0-202307271613.tar.gz"
  version "1.26.0"
  sha256 "ba5fe5ee3b2a8395287e24aef20ce6e17834cf8e877117e6caacac6a688a6c53"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f45e4ec39d771696280c31dd488a3e7b8f5f5776df32672541a0c87793e72c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f45e4ec39d771696280c31dd488a3e7b8f5f5776df32672541a0c87793e72c71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f45e4ec39d771696280c31dd488a3e7b8f5f5776df32672541a0c87793e72c71"
    sha256 cellar: :any_skip_relocation, ventura:        "f45e4ec39d771696280c31dd488a3e7b8f5f5776df32672541a0c87793e72c71"
    sha256 cellar: :any_skip_relocation, monterey:       "f45e4ec39d771696280c31dd488a3e7b8f5f5776df32672541a0c87793e72c71"
    sha256 cellar: :any_skip_relocation, big_sur:        "f45e4ec39d771696280c31dd488a3e7b8f5f5776df32672541a0c87793e72c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f868841a92203f21d389942ab1ae48aa1cb07c4306bc3f5447347784dd2ba19"
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
