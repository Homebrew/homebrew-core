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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "774d6ed602298274d3699e816fb7eafdc1f782b3486bf4f6c77ed1033df43f2f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3c82381a2548645fef4f7f30d2e70b68723464f9999fe06ae63055278d3d67b"
    sha256 cellar: :any_skip_relocation, catalina:      "6e48bb699d8b89a826f6c6c77bad2f0d83a8099b822edb68ab2ad34e0b88466c"
    sha256 cellar: :any_skip_relocation, mojave:        "20f954b372579d0f6362c2b28841ca4252e5717d2134d3aee1c6b4c68c73e5bb"
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
