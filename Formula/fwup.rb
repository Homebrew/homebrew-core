class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.14.1/fwup-0.14.1.tar.gz"
  sha256 "6afb6c6e69e686db6e561b4712dc4ee25a2f2fce387311568981b1c92086976a"

  bottle do
    cellar :any
    sha256 "cb3b5971b6ff3edf5b46cc2a93af8c6ecf88216f173ad316e199acfa18ccbbf7" => :sierra
    sha256 "9a290734145911fbd3fb1a0605d39548433fae65f579fe463514877b1a5acd6d" => :el_capitan
    sha256 "e93b92dc63cc8da05d7639a2714fc74a602b7b058e203009021ed3b8efa6357a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert File.exist?("fwup-key.priv"), "Failed to create fwup-key.priv!"
    assert File.exist?("fwup-key.pub"), "Failed to create fwup-key.pub!"
  end
end
