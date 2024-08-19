class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://andre-simon.de/doku/highlight/en/highlight.php"
  url "http://andre-simon.de/zip/highlight-4.13.tar.bz2"
  sha256 "5ea95f9ab03dd857de4ce0cde68ffacc041d0223bbce0893e2ada9c85503488c"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cc1d54b5cd422334bbdf435ccceeaaea75e004a19be6c6a840b2386e34638b8e"
    sha256 arm64_ventura:  "3d2d044c0e4fbc706aaac772cc878e6c2d469bdc2ce89aeaade88c22e2a88b1c"
    sha256 arm64_monterey: "e99255ad10e933ab272f42c3ac6d7a9624b44796d566df08cf467fad19253994"
    sha256 sonoma:         "93ac7a69fb657dbd7ed355c0575b26c3aee45390838e973b83f9746f8e70b6a7"
    sha256 ventura:        "096ed0232fc4957849c3b2d00a23cdc1865a2d772475792545e4ffa565c9a517"
    sha256 monterey:       "19f5281027935530f6f10ba2107bf7ea1f92d80ae877ba7108bdc649e05cf15d"
    sha256 x86_64_linux:   "f26879fc304ea0a25621ee1682c1d5e879da486afcc0b53c46f03409b55afedd"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

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
