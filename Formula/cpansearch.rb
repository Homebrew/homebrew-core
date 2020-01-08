class Cpansearch < Formula
  desc "CPAN module search written in C"
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/0.2.tar.gz"
  sha256 "09e631f361766fcacd608a0f5b3effe7b66b3a9e0970a458d418d58b8f3f2a74"
  revision 1
  head "https://github.com/c9s/cpansearch.git"

  bottle do
    cellar :any
    sha256 "f5ad7240f2e1d3004c9b80d232192bbc50dcf777bdfe92fa73172e93476f5ef2" => :catalina
    sha256 "5d583c37a54d9d6f96c625faf75b40c53a2ae59b8c9960f51a6f9bc215fa5bae" => :mojave
    sha256 "e8197124d1341e8e5d8348cd322eac2bfa782d885c808b5322a340eb7b91ba8b" => :high_sierra
    sha256 "6b4545b0455642a3b4f3c92ef480e704742cd06fd6ff64d24f9a5edbb3bc33a7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000

  def install
    system "make"
    bin.install "cpans"
  end

  test do
    output = shell_output("#{bin}/cpans --fetch https://cpan.metacpan.org/")
    assert_match "packages recorded", output
  end
end
