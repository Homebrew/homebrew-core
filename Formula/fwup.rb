class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.2.6/fwup-1.2.6.tar.gz"
  sha256 "b7886556a9057aff568ee98feb0fa0b09f4c4d9bb8447bb17c4299c2dcc5fe67"

  bottle do
    cellar :any
    sha256 "0291bad0603b96826a9518710b41261b17cd093d0f78bb6a4a80b7113e72465a" => :mojave
    sha256 "38de88b1f028e49c4405eb2e9553efb4a18443ec33e67536c820aa0249084c11" => :high_sierra
    sha256 "14af77644be3f531267721495c8e26a99ff95fc7474ea316be9138f8e6b5ac8a" => :sierra
    sha256 "86fede8a00c63a115abb4845152f7eeb9ebdbfe016eb6551d2d25dfed3a65084" => :el_capitan
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
