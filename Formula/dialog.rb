class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20210306.tgz"
  sha256 "a73e7b607b635f63c0202bb3313106e700f91fe4a9f4d26ca7003f6eb2b9cb0f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e09724f205584817856ea95da0efea7a7e1dadcd40c710dd1dfe5bd13095c3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "714273a1a397ddce1a4c67d4efb9da0bba77cfd7043a71ee31999f958adb950b"
    sha256 cellar: :any_skip_relocation, catalina:      "7530d0710cb81af8ca5b616c2442eea1e414a366be349c510c4e43d2b5b683a0"
    sha256 cellar: :any_skip_relocation, mojave:        "c7498a57da87fa7a4f56ab04eb8352d225754726657974d3dce6620fe6b4096b"
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
