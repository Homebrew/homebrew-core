class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20251014.tgz"
  sha256 "0ed46949c680a5f42e342cc48a2ce60bcfc2cc8b9eebb176877b5a91f829435c"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "587f92b6b6ccac672d9779aa539cf6407f5c6663981a65526048728d590e94fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d30b788e217dea97bcfbe00f8870aada4f82830a049b1c4438332d4defe9c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23214535daa04a6a731dde13d8b663639ccd32484a906a0fcfe90ab4a4935c05"
    sha256 cellar: :any_skip_relocation, sonoma:        "1061220f7666a70e7cd12c14259d5f682566f4639a9cb058e90fbc9ee03700e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86b9027c86caf2acea7f70048b810073b50f0160cac2d7205925d57bfd1a0376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53cf8a5b7aeae3d90f495dfc46900335106846aee7543d41fdc23476b1ff35e3"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
