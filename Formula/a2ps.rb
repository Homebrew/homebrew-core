class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.2.tar.gz"
  sha256 "ec52904a9fac126416b32ac9a2405f3d617dda97d65299e1a415554fe033d225"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "4eb394a91ad3dbc4fe18d5318710494d5d7e9b9047e739a8514c3fc184cde383"
    sha256 arm64_monterey: "4aa5f9c6dfe0c3b8d2bc180d8b73670af91f268d71031ac2d79101873db1f5ee"
    sha256 arm64_big_sur:  "70af5c9e051d7680e0cb1c0835bbcf9fd9ba2451dcc148258697280979c2cc19"
    sha256 ventura:        "47281f6cf74e0d0daa63e81a232287c4efeb4b3efb952463f1f489b67f18f1c4"
    sha256 monterey:       "5af11af19b77e06c846f77bbe20547141718e929b57a72d8210b709803f56710"
    sha256 big_sur:        "982335fb7f5862dd1501d7ac6830ae2b1de0f5922d063697e00176e391ebb47a"
    sha256 x86_64_linux:   "40d0bf74b992ce203583febda02b3074d743f1b98acd2de77bb68d422466e4b4"
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
