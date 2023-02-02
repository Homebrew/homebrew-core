class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ba57506c17a99356c443d3c4459977c825dcce1b039965ba7699140e11d95afc"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  depends_on "go"

  def install
    system "make", "build-server"
    bin.install "conduit"
  end

  test do
    shell_output("#{bin}/conduit -version").match(/0.5.0/)
  end
end
