class Juicity < Formula
  desc "QUIC-based proxy protocol implementation"
  homepage "https://github.com/juicity/juicity/"
  url "https://github.com/juicity/juicity/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "dab433672ef7bb209443f5f668d1cb6f704ab9ac479013c7e9416b516340ca41"
  license "AGPL-3.0-or-later"
  head "https://github.com/juicity/juicity.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make", "CGO_ENABLED=0", "juicity-server"
    system "make", "juicity-client"
    bin.install "juicity-server"
    bin.install "juicity-client"
  end

  test do
    system bin/"juicity-client", "-v"
    system bin/"juicity-server", "-v"
  end
end
