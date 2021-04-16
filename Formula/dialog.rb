class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20210324.tgz"
  sha256 "01c2d1e2e9af9b083ea200caad084fdfda55178d5bbf4e42c9fff44935151653"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36a7ae1f6265699cd3b75a0c6c3d583fe1516439cc779bf8a5ee4606d1cb8357"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fb719fa5573402c89dfa1ec9662b49727837f408883fe1b634519e87d670ca9"
    sha256 cellar: :any_skip_relocation, catalina:      "5e2c06ad6adbb69ac46cc75b1a71ffeb9becb918e54484563e2da16dfdab5a31"
    sha256 cellar: :any_skip_relocation, mojave:        "34d01a1614762e0ce58b0920ca7ad8433e0d34a77c13b21c5c1e71728afde6ae"
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
