class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.19.0/fwup-0.19.0.tar.gz"
  sha256 "6407c2c999babf4ff71f6c533943a3d7c7ddf29c52242f1071d5b5c313f8c2de"

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
