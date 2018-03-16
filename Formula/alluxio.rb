class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.org/"
  url "http://downloads.alluxio.org/downloads/files/1.7.0/alluxio-1.7.0-bin.tar.gz"
  sha256 "2d66f789bc89d0e01ce0e695848fa3aaff9e236bdc48a6cf9ac501393f4ff23d"

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
