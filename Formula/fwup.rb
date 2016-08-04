class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.8.1/fwup-0.8.1.tar.gz"
  sha256 "edd7f65bf64c28651e3cf93f17eabe8e280d4c28c64fb3536e482be3d2744d83"

  bottle do
    cellar :any
    sha256 "5fff9c96643168ef512d0c07f27addc692e8d5dbc930d83b5b1ff7bd45a6097a" => :el_capitan
    sha256 "8f1eaeed130c8efbe995ec76f45d3c9f2648e8ec4ff76de40fb8fec0d1eff576" => :yosemite
    sha256 "fb01ce18d3fe1e62216dba4ffd141606a39cd7dcaf7829e2f17a80e2ec9386b6" => :mavericks
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
