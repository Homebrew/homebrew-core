class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.10.0/fwup-0.10.0.tar.gz"
  sha256 "a02f81854d8b79fea4376c08da006f8abe8acfd60614f5a5f1f62530e7e11e3e"

  bottle do
    cellar :any
    sha256 "c3c4b84433e771109905667a4d5e943c2c50f14221160cb557889d557641a57e" => :sierra
    sha256 "9acdc7499a2b9fef038205fcf7d251ea053017d6d094cf6e6c76a69cabe26e3e" => :el_capitan
    sha256 "ba275992d4a87671252afbd99012e58838954829b90709f085a6038982f2532b" => :yosemite
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
