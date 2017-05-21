class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.14.3/fwup-0.14.3.tar.gz"
  sha256 "657e2732d9aff172c529cc0e6fe6afe68950d25080e190cb00b7756654508beb"

  bottle do
    cellar :any
    sha256 "8b3000368da1babf1bdd3cc438ab2399acc379a603b0052b958fcf7bb4d8d4af" => :sierra
    sha256 "df20a3a229f35127925ace6d2be0a47213eae8507a84f0ac0b899c77f9780ffb" => :el_capitan
    sha256 "ce59df071c5b40e5019702ce3d3bedfd9a4a88c94f1b032133bc1c08c4472ced" => :yosemite
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
