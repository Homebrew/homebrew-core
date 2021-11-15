class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20211107.tgz"
  sha256 "af97fd6787af2bd6df15de4d1fa4b5d57e22bc7b4c82d35661c21adb9520fdec"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af13fc5ed9ad1130eb1bd077973d0b895291dd5422dd7405b45609628011f92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b43f6824c286c9665a1e7106d9b4a2b515518c5025aa9f87f31d916876ff8235"
    sha256 cellar: :any_skip_relocation, monterey:       "59223925cb93b31d681a6b6c862eb6e66c743f65beea211fc9175f8277511282"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d773e2ce233dc636b9a3d87752c5b64e69811c25dde29aca2a88c42aa2f92a6"
    sha256 cellar: :any_skip_relocation, catalina:       "5993d6c28363a0c091654e1f077f09b7181d861b8100ac5e749da70f948a8231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "841dc3155471f07bab41a4fc1c83d3331903eee41aa94d7e2d987df46ba5cad1"
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
