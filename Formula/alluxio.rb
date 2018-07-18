class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.org/"
  url "http://downloads.alluxio.org/downloads/files/1.7.1/alluxio-1.7.1-bin.tar.gz"
  sha256 "40f7357663b2bdf9e15345ef6cd79ef9c669635e7538725b199cb75ee2af4fa9"

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
