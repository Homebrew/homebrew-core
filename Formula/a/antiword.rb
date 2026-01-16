class Antiword < Formula
  desc "Utility to read Word (.doc) files"
  homepage "https://web.archive.org/web/20221207132720/http://www.winfield.demon.nl/"
  url "https://web.archive.org/web/20221207132720/http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz"
  mirror "https://fossies.org/linux/misc/old/antiword-0.37.tar.gz"
  sha256 "8e2c000fcbc6d641b0e6ff95e13c846da3ff31097801e86702124a206888f5ac"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "f3a917d197df7b1a9e21a9e604593783436adff1b8c6854a85ef417abc3ca21b"
    sha256 arm64_sonoma:   "393500bd0690bd7fdb9ed258a1ce7882f518db42ec14d380421f771467080bf6"
    sha256 arm64_ventura:  "c4d6bfce24638c2f087af1f8bab031848f27584bbc4497d2b11913d9562a0047"
    sha256 arm64_monterey: "3d34f162686148d496bee36265f1434f11daf29957de15c4bdce8ba386f90fc9"
    sha256 arm64_big_sur:  "b47c2693abcaa8e3b9bc14a4239b1cd857f66f1fa381009659b7e1bc7f7d52c2"
    sha256 sonoma:         "7c0d5b36540d2d65aa86290dbc58abe08731c1a8619720e4465ed33103bcef88"
    sha256 ventura:        "60dace4917a561e05ff9bcce49bdedab2d1e39b5e5b2bb3c7f81bb4b14c3e2e4"
    sha256 monterey:       "2532dc5dd6a92569c650fd6bb490fae31c49d79234948c224f51df5910fbecc9"
    sha256 big_sur:        "d155e9094844588db872b6791fe727bb72fac4a72d9897bac768a813c1bf273a"
    sha256 catalina:       "7f62624bf238ba077370f6e8e223704b57eee461f2bbaddc47de8e4b5c5a4eda"
    sha256 arm64_linux:    "80b3df205c403d29dc8f09ddfd181a3418b2ad6b84f7f54029717d1326896a48"
    sha256 x86_64_linux:   "12935daff8ed3ffc2a68b8be542ea190bff6d7d2a2d46c854080d4023346d526"
  end

  deprecate! date: "2024-06-19", because: :repo_removed
  disable! date: "2025-06-21", because: :repo_removed

  resource "testdoc.doc" do
    url "https://github.com/rsdoiel/antiword/raw/fe4b579067122a2d9d62647efb1ee7cfe3ca92bb/Docs/testdoc.doc"
    sha256 "4ea5fe94a8ff9d8cd1e21a5e233efb681f2026de48ab1ac2cbaabdb953ca25ac"
  end

  def install
    inreplace "antiword.h", "/usr/share/antiword", pkgshare

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags} -DNDEBUG",
                   "GLOBAL_INSTALL_DIR=#{bin}",
                   "GLOBAL_RESOURCES_DIR=#{pkgshare}"
    bin.install "antiword"
    pkgshare.install Dir["Resources/*"]
    man1.install "Docs/antiword.1"
  end

  def caveats
    <<~EOS
      You can install mapping files in ~/.antiword
    EOS
  end

  test do
    resource("testdoc.doc").stage do
      assert_match <<~EOS, shell_output("#{bin}/antiword testdoc.doc")
        This is just a small test document.


        This is just a small document to see if Antiword has been compiled
        correctly.
        The images will only show in the PostScript mode.

        [pic]

        Figure 1

        This JPEG image is the Antiword icon.

        [pic]

        Figure 2
      EOS
    end
  end
end
