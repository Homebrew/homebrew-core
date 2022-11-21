class Most < Formula
  desc "Powerful paging program"
  homepage "https://www.jedsoft.org/most/"
  url "https://www.jedsoft.org/releases/most/most-5.2.0.tar.gz"
  sha256 "9455aeb8f826fa8385c850dc22bf0f22cf9069b3c3423fba4bf2c6f6226d9903"
  license "GPL-2.0-or-later"
  head "git://git.jedsoft.org/git/most.git", branch: "master"

  livecheck do
    url "https://www.jedsoft.org/releases/most/"
    regex(/href=.*?most[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f77965c676d147011c6456b7da9f7097d02e5de8fb81a0282b9cb6a5caedc527"
    sha256 cellar: :any,                 arm64_monterey: "a59940ffff8a004be1e310759e22c16d3c69521e9c8bf7c7a75dd8c919cc8d4b"
    sha256 cellar: :any,                 arm64_big_sur:  "f45ef961fdb9f6cc835bef242de3f22abce43b27c8e9fead3351c84da8523a2f"
    sha256 cellar: :any,                 ventura:        "464f7b8e15dd5c9dbe5f4ca3d39eeb7d7788ea61dbf336180f1d9a864085dc0d"
    sha256 cellar: :any,                 monterey:       "e5661527b7f93c4f8277d58508004f5c6ddd642b1b72ace3364df24593c2bfac"
    sha256 cellar: :any,                 big_sur:        "a2839cdbb2da468947d084bb3f78f9c4b575d8d090f59ae0c24a09bf86c8d67c"
    sha256 cellar: :any,                 catalina:       "9a61d3f7087d729dbb2d9aa01d32d6ab59330ef64711ce080e6702a8fbae3bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "701edb9b61b659c7b3531b3527ede68e563a19b8ef989efc537e2400b4259233"
  end

  depends_on "s-lang"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    text = "This is Homebrew"
    assert_equal text, pipe_output("#{bin}/most -C", text)
  end
end
