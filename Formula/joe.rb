class Joe < Formula
  desc "Full featured terminal-based screen editor"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.6/joe-4.6.tar.gz"
  sha256 "495a0a61f26404070fe8a719d80406dc7f337623788e445b92a9f6de512ab9de"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/joe[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "5e8ac5942ca4dd172e198fe4f756d9b8bfb7f614766485dbf361aa77c6843c42"
    sha256 arm64_monterey: "affefc197630adfb4ae357d8e144dabd0920022d9b9a9e4a3cad537629c3048b"
    sha256 arm64_big_sur:  "24bd1c0ba2e1f70bf85d2cf403612dfefed70fa1d1441121e560184146b8a036"
    sha256 ventura:        "910933a1873d8f2debe547b5f6f2ff67726938e73d2dd79a060088637cf34b69"
    sha256 monterey:       "4eca39a7205e80d0be7c9eacad34c1af5c2b2f7ac062b803a7245762efec9498"
    sha256 big_sur:        "f108312e44e035b6475a7dc91096eb65cea4567cf00a9ad9b21f69da06af65ec"
    sha256 catalina:       "ec0e97a7a7ce9b63775dcc978f23efe2780a7319f1746246b092378f04e2caf6"
    sha256 x86_64_linux:   "ca9c9790b7d1c6b64cec4974c90d6855bd2e977b80399a7240d2a3392551a874"
  end

  conflicts_with "jupp", because: "both install the same binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
