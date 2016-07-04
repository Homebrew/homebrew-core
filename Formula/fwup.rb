class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.8.0/fwup-0.8.0.tar.gz"
  sha256 "9d249cb8b73919eec85645e31d9ba346b1d02e297d747d969c2ba5dff9d2a12a"

  bottle do
    cellar :any
    sha256 "590bfdf523902eec53518ca36a1913a32b42080b8533b588a1116d2e33197263" => :el_capitan
    sha256 "aeb822c13562919113be2cf8b55214776a338021b6270b3f45505faf585c0fe1" => :yosemite
    sha256 "5fe1615e422ccfe484aa81c8d7cbdd6a7cc59b86bb14d5965cac9c03a771a76c" => :mavericks
  end

  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/fwup", "-g"
    assert File.exist?("fwup-key.priv")
    assert File.exist?("fwup-key.pub")
  end
end
