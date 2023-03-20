class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.2.tar.gz"
  sha256 "ec52904a9fac126416b32ac9a2405f3d617dda97d65299e1a415554fe033d225"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "fc42e0092608f9ef0d6b58ae9ea6c9169d7f1ed2254bb4e853b64ae0211a524b"
    sha256 arm64_monterey: "73716b5705accbc90ddee8cd4217b96196aa18a7ddd33f71c61e1163161b964b"
    sha256 arm64_big_sur:  "2be1aba4da4eb148f70e472e3cf730bf683573c05623f79cf814d69d2b40f862"
    sha256 ventura:        "93548ad781a7977662ae735698c6b65eb6d60fbf857020bc750b2a9cbe2a1bb4"
    sha256 monterey:       "4f9c4713dbad720076dff95391dfeb8d2f291b09babba23640191c86cb7be989"
    sha256 big_sur:        "1f2e0179c49b21d40902c0e8ddbbaa802959c44c029a0a6c3030656e3b4009a5"
    sha256 x86_64_linux:   "7d1812595f9555173f0ee2e58d8c7cec3b2fdb3dd6acc39f45d9fa414a44e401"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "libpaper"
  uses_from_macos "gperf"

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}",
                          "--with-packager=#{tap.user}",
                          "--with-packager-version=#{pkg_version}",
                          "--with-packager-bug-reports=#{tap.issues_url}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
