class Aview < Formula
  desc "ASCII-art image browser and animation viewer"
  homepage "https://aa-project.sourceforge.io/"
  url "https://downloads.sourceforge.net/aa-project/aview-1.3.0rc1.tar.gz"
  sha256 "42d61c4194e8b9b69a881fdde698c83cb27d7eda59e08b300e73aaa34474ec99"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad92a0e964ccbebe685edf9c595efd420475490d255caed072985cb128a8230b" => :catalina
    sha256 "fe70cf7dbd1d2e1473da3818b96d3a94d811e93d52ecbb6ecfc1c1e1ccb8b12a" => :mojave
    sha256 "4f5fa09318475fca46c584b52e5d5b845cd4d331df04744ca41d6789575b32ec" => :high_sierra
    sha256 "95cbb14a2a5cb4d8d11d9ca3621e81705df77f47d85f89383913e3a02da56041" => :sierra
    sha256 "cb20b8513b3b7d2977943d7ba14f2627892697e9a6b69c4366563786810ca95c" => :el_capitan
    sha256 "886a6800deefcf7a1e377db57c9df0579b6f1fcb4b491a6262171411bce3517b" => :yosemite
    sha256 "142a0b64e457e900e395f35d5112bd968e605fa6182bdc9ca77b923a5e5263f6" => :mavericks
  end

  depends_on "aalib"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aview/1.3.0rc1.patch"
    sha256 "72a979eff325056f709cee49f5836a425635bd72078515a5949a812aa68741aa"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/aview", "--version"
  end
end
