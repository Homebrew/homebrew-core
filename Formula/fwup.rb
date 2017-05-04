class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.14.2/fwup-0.14.2.tar.gz"
  sha256 "4ca9ce1c408ca110dfc1de47f0981e052c7da5d11780f7b290056ef4367b28fa"

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
