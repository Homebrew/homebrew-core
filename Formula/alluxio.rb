class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.org/"
  url "http://downloads.alluxio.org/downloads/files/1.8.1/alluxio-1.8.1-bin.tar.gz"
  sha256 "5565b4a55331458da087c35d9612165a399a8fcc2221c7bc4665eac8b5f7ab5c"

  bottle :unneeded

  def install
    doc.install Dir["docs/*"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    (etc/"alluxio").install libexec/"conf/alluxio-env.sh.template" => "alluxio-env.sh"
    ln_sf "#{etc}/alluxio/alluxio-env.sh", "#{libexec}/conf/alluxio-env.sh"
  end

  def caveats; <<~EOS
    To configure alluxio, edit
      #{etc}/alluxio/alluxio-env.sh
  EOS
  end

  test do
    system bin/"alluxio", "version"
  end
end
