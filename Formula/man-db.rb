class ManDb < Formula
  desc "Modern, featureful implementation of the Unix man page system"
  homepage "https://nongnu.org/man-db/"
  url "https://download.savannah.nongnu.org/releases/man-db/man-db-2.8.5.tar.xz"
  sha256 "b64d52747534f1fe873b2876eb7f01319985309d5d7da319d2bc52ba1e73f6c1"
  keg_only :provided_by_macos
  
  depends_on "libpipeline"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-systemdtmpfilesdir=no",
                          "--with-systemdsystemunitdir=no",
                          "--disable-cache-owner",
                          "--disable-setuid"
    # NB: These CFLAGS can be dropped once man-db 2.8.6 is released
    ENV.append_to_cflags "-Wl,-flat_namespace,-undefined,suppress"
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "install"
  end

  test do
    ENV["PAGER"] = "cat"
    output = shell_output("#{bin}/man true")
    assert_match "BSD General Commands Manual", output
    assert_match "The true utility always returns with exit code zero", output
  end
end
