class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20230209.tgz"
  sha256 "0c26282305264be2217f335f3798f48b1dce3cf12c5a076bf231cadf77a6d6a8"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aeac7ff5d3b3433417a2635b058db610ac8027c6afc3b238397a78e9801b6fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be6f2c9938287531f3a729593cc887c6175fa7fcbfd97cf3532ba551af270458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f624e68c6e96b98c78cf402aaa97e771c3e81086cd1953aba8d379852c0d23f9"
    sha256 cellar: :any_skip_relocation, ventura:        "ce9ac1501730032923f3e787614edca21ba36380d1946d1d9f72bfabd9fa42f0"
    sha256 cellar: :any_skip_relocation, monterey:       "91c0c7701d88da6415deb0782d76943a97eac62332e7264ae5479b17f2d79d38"
    sha256 cellar: :any_skip_relocation, big_sur:        "40c3a25049f5f9525be371e530a115b8855854e91f04c938b9b88aae552c8824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad3107ff1f484d87fb7bd99a76d76c1e891c0a7e70f45395aa4b509b7dad50a"
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
