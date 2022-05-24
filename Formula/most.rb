class Most < Formula
  desc "Powerful paging program"
  homepage "https://www.jedsoft.org/most/"
  url "https://www.jedsoft.org/releases/most/most-5.1.0.tar.gz"
  sha256 "db805d1ffad3e85890802061ac8c90e3c89e25afb184a794e03715a3ed190501"
  head "git://git.jedsoft.org/git/most.git", branch: "master"

  livecheck do
    url "https://www.jedsoft.org/releases/most/"
    regex(/href=.*?most[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8138708939ce792e60ae62f2833ea4068d7c2f5862113d3f761815e3018d183"
    sha256 cellar: :any,                 arm64_big_sur:  "fd73f2437d47c7c7eeee75514321666ed2a8d72f996a67b46e6822dc73a32155"
    sha256 cellar: :any,                 monterey:       "3fba92e92d066b318e78c8f59a97ae60680e0a1018ce3db36d037e298bdb4f23"
    sha256 cellar: :any,                 big_sur:        "dc824da94e802ecb474eaccd9f3d89b37288846250dfeded7d065ccc43cd208d"
    sha256 cellar: :any,                 catalina:       "2971d721787d978c1855827c1f2cb6143ee0d1efabdfe1caa50bda981865a24d"
    sha256 cellar: :any,                 mojave:         "aa9766e4fa0be084108b370c639060b7a27e5ff8eb90c649cbc643160659932f"
    sha256 cellar: :any,                 high_sierra:    "192ccb3fe86ae7766bd1aadb8e92d8bc7a28cb666fffe52d0750c6c2a4450657"
    sha256 cellar: :any,                 sierra:         "9a9d74a50ade82af787d47e5f6514df01a47b5159dc1521d93c470ce8554743e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a076d8ffb8b1dfeb9cb8856725b5e9c60dbc442d7096f01c0d2b8f31868bb95c"
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
