class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20240619.tgz"
  sha256 "436f14e8a756e63ddff5927eef70c9dcf71e4c59d56587e26302a4f726a19eff"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c42a812f035b3471e1bb37443c8c61fc5f9d6a5952fcc0ba44f62326d9f63cff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95a814de7b05548c1aeb3e7b0851aa1592651e3fa09b85457077aaaf558b44d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5863f644998665a50da5005f57ffa011af99d7116e7d95a18688406a034975dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b02594c848187a4b52bb4481deb070b56dd07a15f5fa8b2376cc5e5e0d32c89"
    sha256 cellar: :any_skip_relocation, sonoma:         "40d9312ed14fbedef7778a6747108b81de74574b467ccbea42f530b18fe91ff2"
    sha256 cellar: :any_skip_relocation, ventura:        "b1285f22b1ab622991a2e73d29df91afccc2c3440a2e3d21bf3df0e1bca9d0bb"
    sha256 cellar: :any_skip_relocation, monterey:       "228a11464e278e71935221feca7dfb25c2e9195dd5e8a33b836d6b3a8f1ca685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16cb26d2db3f3655683c0a9267c006350786fd60e4246cd6c26c01faf96873d"
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
