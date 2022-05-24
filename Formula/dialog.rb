class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20220414.tgz"
  sha256 "493781718642cdd58bdba1cdf2a26776ca855908710d813bd2e93810dc49ece2"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0230382a2b86d078e5662744c8560153064db948a0811f4948469711f4a68709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7057e5b7be1abdb9c1b1c115a844cd674ea73dbf4341077db6e5a50c9e21ee7f"
    sha256 cellar: :any_skip_relocation, monterey:       "3a06d0fa9da01a0c3e730a6fcfac6c79bf1649d20a8b929d1e816f48713dc29c"
    sha256 cellar: :any_skip_relocation, big_sur:        "16cbcacaf52f70a3bf46d4c29339a94db9f8b2bb4600876ced6315ac6698c134"
    sha256 cellar: :any_skip_relocation, catalina:       "fc65589ab726ac60670fa3e54970119e4955e92a322eab1f5949593628641c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bf0ef5dd39ea9daf83d473a88bfcb4d9c8313f3a1c1067484cb166c9a925449"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
