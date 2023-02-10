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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94475df999c95c2ca28576abb61a3f5e58aa99944991a6815317e0ecb85ba27f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e316785f387ef9a43a6db722c076206c7aedf9db63c0271322cda2f7b910a622"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed1408332197d4d4d05c4ee8c4a75d74a90f4e348ba488bc126473d314d75679"
    sha256 cellar: :any_skip_relocation, ventura:        "059a3ccc84408b6b532530a854f317bc7f9f23ffef28c8262aa75391a6897804"
    sha256 cellar: :any_skip_relocation, monterey:       "b74f15d087ae9cc6a0c36b1773b62e8342e6b0814889b50994c653b86b23c581"
    sha256 cellar: :any_skip_relocation, big_sur:        "889f6147706fa1e58ec94f26568d7f5a8a8ac3dc573c0faa5ecfa46052fbcf84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34f7ad67eec16c209056c57e457e68adf3866fd332f068fba67550e6b940abf1"
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
