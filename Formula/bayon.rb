class Bayon < Formula
  desc "Simple and fast hard-clustering tool"
  homepage "https://github.com/fujimizu/bayon"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/bayon/bayon-0.1.1.tar.gz"
  sha256 "1749f8d2202459e33dd739e62fd8c128facaf16a06cb3f38a9e4f10cce542e0c"

  depends_on "google-sparsehash" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bayon", "-v"
  end
end
