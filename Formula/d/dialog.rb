class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20260107.tgz"
  sha256 "78b3dd18d95e50f0be8f9b9c1e7cffe28c9bf1cdf20d5b3ef17279c4da35c5b5"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d64fa165ed8b784856419606889e4d09cc9fb1f19a4794387d4c860250be152b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d341571dfea558887addbed6a68b7a293c4d67c4e9bf30a83ad7710bd8ac6481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ded42fbce83d1bbcf73f8eb94a7ac16576126ea9c3db93ea5a748929dfddda19"
    sha256 cellar: :any_skip_relocation, sonoma:        "9402a49400c97b1599256b147025e734455bb646a7585546a4b7d4ffa12824af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9394791d2ca344fad76f18bfec4c1a95db88e7efc3e54716fd8141e786d76f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3fb12145e5e790ea2cb32f23ecae13fea18aa776adb7053418b2731d55c7beb"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system bin/"dialog", "--version"
  end
end
