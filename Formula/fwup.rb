class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.18.0/fwup-0.18.0.tar.gz"
  sha256 "5f049d3007f278ca80cf3c6454b5c1493672f27807672ecd9928c1b5de935c5e"

  bottle do
    cellar :any
    sha256 "5bc1a5bc7e779d2eeb43ddb824680a5dd908127380c60368d0e99ae2863ff7ee" => :high_sierra
    sha256 "7a567711e6323d423457464516ae1d513aefbf8db2931689ddfac74213af8964" => :sierra
    sha256 "fe29e43fcad130de8513b25d2d109c00747a9304aa99229f2ab4a62cff536bb5" => :el_capitan
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
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
