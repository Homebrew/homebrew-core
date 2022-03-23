class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.2.tar.bz2"
  sha256 "ed3efdb9b416b236e503989f9dfebdd94bf515536cfd183aefe36cefdd0d0468"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "caf613faeea04598af9f40e33f0035584250cb690bd2747374b932a562f16f04"
    sha256 arm64_big_sur:  "4334f3d71cd6c4e5b452154f7b9d1386d921afc9805bcbafd18c4a945a88dbac"
    sha256 monterey:       "f9fd20137f1c3bba43234e0d1ef181ff37001e226f4887d1c168be726c989514"
    sha256 big_sur:        "2cf01ec552ef0d2367aa9aecd1606cbee37c17e009bd72e371f8375e416d2a3f"
    sha256 catalina:       "5bb748bd4cdc0211a157d2a846bb2921cda8c35a3c2508acb17290a376b66010"
    sha256 x86_64_linux:   "e60a62a021aee25dd40cd2fed076a7700f8a943da70927a0d4fd934945b69245"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # needs C++17

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
