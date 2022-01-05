class Jdtls < Formula
  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse/eclipse.jdt.ls"
  url "https://download.eclipse.org/jdtls/milestones/1.7.0/jdt-language-server-1.7.0-202112161541.tar.gz"
  sha256 "2f0c28dfec317a268ec44904420657181b43a7ba2a32f0bf788ea388dacb8552"
  license "EPL-2.0"

  depends_on "openjdk@11"

  def install
    etc.install "config_mac" => "jdtls"
    libexec.install "features"
    libexec.install "plugins"

    bin.write_jar_script \
      libexec/"plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar", \
         "jdtls", \
         "-Declipse.application=org.eclipse.jdt.ls.core.id1 \
          -Dosgi.bundles.defaultStartLevel=4 \
          -Dosgi.checkConfiguration=true \
          -Dosgi.sharedConfiguration.area=#{etc}/jdtls \
          -Dosgi.sharedConfiguration.area.readOnly=true \
          -Dosgi.configuration.cascaded=true \
          -Declipse.product=org.eclipse.jdt.ls.core.product", \
         java_version: "11"
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
      stdin.close
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
