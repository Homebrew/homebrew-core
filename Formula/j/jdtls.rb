class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse-jdtls/eclipse.jdt.ls"
  url "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.54.0/jdt-language-server-1.54.0-202511261751.tar.gz"
  version "1.54.0"
  sha256 "1a291a269bd88b3c4048219122961a52ec80872afbc7a3f34270b2ce77f7a14c"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa582e37faa69f15da8784cbed329294ba17cf3c89f16ded7e6026634ffabdfa"
  end

  depends_on "openjdk"
  depends_on "python@3.14"

  def install
    libexec.install buildpath.glob("*") - buildpath.glob("config*win*")
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

    Open3.popen3(bin/"jdtls", "-configuration", testpath/"config", "-data", testpath/"data") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
