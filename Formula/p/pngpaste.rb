class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/refs/tags/0.2.3.tar.gz"
  sha256 "6221201cb05191855f0d2707ce7f4055f6e1330de8efc09d386be2a6629f543b"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "54f10ac12b67938941a167fd959d4bda563c37a23b4cf1407513e855f75fba78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c50c153907877dd733f9e98807bf00246a12cb2f8add332a9e3842fe6057cf9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15c6b1b199b6fb33956d42c3bc0cbe2f6d19ed8a578ecf49e44234fec474534c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a78c376be51591db8cee5254f92b275a0d7c5516b96818400b60786a6b1a7b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1199369118afc2095238084d9b632fc8d277b17d4a73d2edf40582e4d329614f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d28443efa53d8c51e0ba85a6985506cc21aad15a346df76ff04c2eea0acd33ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7dca23ac978315853e90df0fd9da592b219837a0493858a33db081246d98ead"
    sha256 cellar: :any_skip_relocation, ventura:        "b41718216a8c084f6c8aa9324e17083daa05dd4a1099e71f0e317cbfca2f92d6"
    sha256 cellar: :any_skip_relocation, monterey:       "e9a350b69811aa02e6b01d906cc184f35a8806e322bf62430b81bff8a6d27fd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d394d6036f0ffe382b36151c15d3ea9b20ce9d1e5fe6166ce11546c5e871f4"
    sha256 cellar: :any_skip_relocation, catalina:       "692e8f099ee7426310daa078d6bf2103b763b4549804f1775a5238acb1ead616"
  end

  depends_on :macos

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert_path_exists testpath/"test.png"
  end
end
