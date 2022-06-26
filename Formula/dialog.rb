class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20220526.tgz"
  sha256 "858c9a625b20fde19fb7b19949ee9e9efcade23c56d917b1adb30e98ff6d6b33"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "053937d0f1b8b8edc8eaae4a99d2b2d5c7b3bca38731dc6ecd80fa0d75773851"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99c12f1af4c9dbb9b709952bee5481325586b784bfcf463cf3881d4290172568"
    sha256 cellar: :any_skip_relocation, monterey:       "4f36a9baff2209ba023b323f82bea9d9f55d955378621f75be74f9f9658ace1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0701269128c16d30f28c8bbd183e6ce903326fd62eedef3b93a9d251fee55159"
    sha256 cellar: :any_skip_relocation, catalina:       "6f984cc9cbe2bb194741f896034c872f28ae44cc7cf2faff5acb38e8b2e6b86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc422560715fa5aefd571febc1c519a5a5c8f18253bbf078cd6f4279e769690"
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
