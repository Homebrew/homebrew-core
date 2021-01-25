class Podiff < Formula
  desc "Compare textual information in two PO files"
  homepage "https://puszcza.gnu.org.ua/software/podiff/"
  url "https://download.gnu.org.ua/pub/release/podiff/podiff-1.3.tar.gz"
  sha256 "edfa62c7e1a45ec7e94609e41ed93589717a20b1eb8bb06d52134f2bab034050"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.gnu.org.ua/pub/release/podiff/"
    regex(/href=.*?podiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cf8359a976f7bccc111f28c41d2b33fdd5ee3bb28077d25c79f3c5fedb5c7286" => :big_sur
    sha256 "2502706ba85e9c2f373180fdeacced6d93c3495f7a73dbccb86a750d65a127ca" => :arm64_big_sur
    sha256 "8178fa230e77c829fce5aed7fc48dd3727dea6a3247008094cfc0d8fb5209964" => :catalina
    sha256 "421503a19273f2dc2149549229d6a51508f23c6b9151ed6046afdcef9a54bfce" => :mojave
  end

  def install
    system "make"
    bin.install "podiff"
    man1.install "podiff.1"
  end

  def caveats
    <<~EOS
      To use with git, add this to your .git/config or global git config file:

        [diff "podiff"]
        command = #{HOMEBREW_PREFIX}/bin/podiff -D-u

      Then add the following line to the .gitattributes file in
      the directory with your PO files:

        *.po diff=podiff

      See `man podiff` for more information.
    EOS
  end

  test do
    system "#{bin}/podiff", "-v"
  end
end
