class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.2.3/fwup-1.2.3.tar.gz"
  sha256 "4f024b118b99b21590158ec5a5045a44d970333c6bbb84377cc6f994ccb7b493"

  bottle do
    cellar :any
    sha256 "da5d308dcb8864a0a55320c0324bde50f1fac8defc678b8edc2fe7118fa52628" => :high_sierra
    sha256 "ebd441e40048e13876375e489ae6ef46272d029831befd5d47031ac5aefc0f26" => :sierra
    sha256 "50e21f2446421e0e924155d5a3cbbab3f36826368478460ba91338994441a3a2" => :el_capitan
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
