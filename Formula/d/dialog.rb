class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20250116.tgz"
  sha256 "68406329827b783d0a8959cc20a94c6e1791ac861a27f854e06e9020541816dd"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d2469f63747ff4fd24c4f56ed8c40fc25bf9ad4b7125641efade529ec966910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "730c804e04d5d9da67ddde062fa9434f022b7739b376c4b49a93161db69dcda1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c592b9a7cc4715b80b7461cd020a4de1672f17b845d70c2e77bb55670b660bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c5ed508d93b2fc7635c23d7fb5dbfc7c5edf336dc461e4b8b351b34ea09643"
    sha256 cellar: :any_skip_relocation, ventura:       "c1ba6e432599dae77a21e6a22107b5b432bfc66d5036d0adfde9c52aa181f7de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7421e7e70ba47204b66907bab7aebe101a3b35ed94b92f8c1b2f10ff81284711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f46ba5552ed2d230e0a3fb2aa544e98a2638f7ff6e6af8731a1d69726840179"
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
