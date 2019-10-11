class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-4.2.tar.gz"
  sha256 "7d339674b6a95aae1d8ad487ff5056fd95b474c3650938268f6a905c3771b64a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdd460be7f04a61f6f39f6c01eae2b6c00b60ce81038099a3f2006c72ff5d92f" => :catalina
    sha256 "9c4a6b8e45092ee0d3d85950b8b2e6bd1826622c2d0fbd34f7128dc521b9db28" => :mojave
    sha256 "2f29dd826dd9c11a5d3be999d12e1728280d6fcea8a5b4d1cdd3cbc076bb9640" => :high_sierra
    sha256 "7f3cf105d16e65ee1911babd08cab37faf69cc29bdcf55c38221102fa52d7a6d" => :sierra
  end

  head do
    url "https://github.com/schweikert/fping.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_equal "::1 is alive", shell_output("#{bin}/fping -A localhost").chomp
  end
end
