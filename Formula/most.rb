class Most < Formula
  desc "Powerful paging program"
  homepage "https://www.jedsoft.org/most/"
  url "https://www.jedsoft.org/releases/most/most-5.1.0.tar.gz"
  sha256 "db805d1ffad3e85890802061ac8c90e3c89e25afb184a794e03715a3ed190501"
  head "git://git.jedsoft.org/git/most.git"

  bottle do
    cellar :any
    sha256 "2971d721787d978c1855827c1f2cb6143ee0d1efabdfe1caa50bda981865a24d" => :catalina
    sha256 "aa9766e4fa0be084108b370c639060b7a27e5ff8eb90c649cbc643160659932f" => :mojave
    sha256 "192ccb3fe86ae7766bd1aadb8e92d8bc7a28cb666fffe52d0750c6c2a4450657" => :high_sierra
    sha256 "9a9d74a50ade82af787d47e5f6514df01a47b5159dc1521d93c470ce8554743e" => :sierra
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
