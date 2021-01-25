class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-5.0.tar.gz"
  sha256 "ed38c0b9b64686a05d1b3bc1d66066114a492e04e44eef1821d43b1263cd57b8"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "012cad012acbaf32885f1d260cfa464478a0a71ad396f0711813c7f2b183112d" => :big_sur
    sha256 "65a1a6e1fee0af28a38006e2ce05f71915080907cacc8bb7ef4373ae041e75f2" => :arm64_big_sur
    sha256 "bd1255921afca543ba440bbf84f86f7c3b0b10db4bbf1aa659a2aa686496e4d5" => :catalina
    sha256 "47f38d4902f03da1e407331848e1f3a75a2b8692e4366d8a0a341e66f36962f1" => :mojave
    sha256 "e2d14a6c1de9032a244f7185ba8a629d61f8ed2964b96490890c87336ff4d521" => :high_sierra
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
