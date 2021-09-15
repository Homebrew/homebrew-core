class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20210621.tgz"
  sha256 "c3af22ccfcd9baca384062108dd9354e86990929ee270c239eef69518c5da7c8"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b46e417d73e065176006d358a36cd293d3f9d881b7b6aea5b2be3fa0a381e721"
    sha256 cellar: :any_skip_relocation, big_sur:       "990bbe5e7a36febc23c79bdbbc454075d695a54dd730e4dab8465d7a66ecab0d"
    sha256 cellar: :any_skip_relocation, catalina:      "87d270268a38de209e9b6fde7c963e4467554d7f0777425f2aa55a3701f25559"
    sha256 cellar: :any_skip_relocation, mojave:        "c05946dd7b57aa11f42ccccd0aab7c9b1506e8093c9dcc60588046aadd4b15dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e3820b717ffdec0e6fe7fce8da31784263ebac9ecd49713677dccf5cc5446b"
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
