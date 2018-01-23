class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.0.0/fwup-1.0.0.tar.gz"
  sha256 "4211042be90ea130d52271f321d39ab164fc410bdc769e38ab44daf04e1b4a95"

  bottle do
    cellar :any
    sha256 "a6cc40087ce3735a93454d8765c483392f06c5b4cf0bedd96b8703ad9f100b7e" => :high_sierra
    sha256 "208fca42d70ab2233926df358d1c1b99c283acb7be294454ddc1c2656f2c7369" => :sierra
    sha256 "3e0cde8098b962d54bf75b1b0f4b368bc5c3421b90c810cfd65c35e67d95813e" => :el_capitan
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
