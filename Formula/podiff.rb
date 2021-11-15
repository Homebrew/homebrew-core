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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f87fb2717a64e8f1783b9795df1cc257e1d972c48813261f3dd08d72dc112d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2502706ba85e9c2f373180fdeacced6d93c3495f7a73dbccb86a750d65a127ca"
    sha256 cellar: :any_skip_relocation, monterey:       "30517e646bd79bc46167c3aee26a3a55069bb121abdedac6490cfa503a4f329a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf8359a976f7bccc111f28c41d2b33fdd5ee3bb28077d25c79f3c5fedb5c7286"
    sha256 cellar: :any_skip_relocation, catalina:       "8178fa230e77c829fce5aed7fc48dd3727dea6a3247008094cfc0d8fb5209964"
    sha256 cellar: :any_skip_relocation, mojave:         "421503a19273f2dc2149549229d6a51508f23c6b9151ed6046afdcef9a54bfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499d50ac3ad81f197ca3c7e158e488d00cd2fbfcf76c194b7799d85a5a89dd1c"
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
