class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.0.0/fwup-1.0.0.tar.gz"
  sha256 "4211042be90ea130d52271f321d39ab164fc410bdc769e38ab44daf04e1b4a95"

  bottle do
    cellar :any
    sha256 "65333ec43ee41271ef08b1718988d9f6d8f7cf828ce8b82bcb1032e9c7f9f780" => :high_sierra
    sha256 "ed8421e355a86f97aa1a4ec492aa13104e95385222bd61467ec7e0bef43fd4dd" => :sierra
    sha256 "5795d3b77a3e115423a4766cfea0845c3eb81265fa2b20d41439e9682d99f6e3" => :el_capitan
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
