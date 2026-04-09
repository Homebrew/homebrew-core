class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "c17d0cc1b3323f72b2c1a5b183a9fcef04e8bfc53c9679a4e1523642310d22ad"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66557c80ff43f15110e291740e2316392dc18ba4fb54dae5a15af57f5979e7db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9bf36ebaba8ea4c9caf8bb17ab50cf057ece008d833c9c223425a093694fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc648c0c02b3bf102a02fcb9e08919a361d401017fb4d2867679d29a3f8187f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c209d74e947383bee551fb90c709fc46563ef924b69715b1dc5babdc5c033a51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd6c57b4f4ca70158ec4b3b7849f0097fc57a83e70020f3dbf23dcd74ef9ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fd6c57b4f4ca70158ec4b3b7849f0097fc57a83e70020f3dbf23dcd74ef9ab4"
  end

  depends_on "feh"
  depends_on "libcaca"
  depends_on "recode"
  depends_on "spidermonkey"

  on_macos do
    depends_on "bash" # Bash 4.1+
    depends_on "coreutils"
    depends_on "gnu-sed"
  end

  def install
    sed_args = OS.mac? ? ["patch_gnused", "GNU_SED=#{Formula["gnu-sed"].opt_bin}/gsed"] : []
    system "make", "install", *sed_args, "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/plowlist 2>&1", 15)
    assert_match "no folder URL specified!", output
  end
end
