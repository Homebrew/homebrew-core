class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash/"
  url "https://ftpmirror.gnu.org/gnu/datamash/datamash-1.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/datamash/datamash-1.9.tar.gz"
  sha256 "f382ebda03650dd679161f758f9c0a6cc9293213438d4a77a8eda325aacb87d2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "024c8e8b9117739fa27275f1dcf4a683282b2e255041fd532097da1c49abe802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8cf2d4dc46574a42e8602a933b68fedf07cf904e14fc08f945d615df872ae42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6e596a1a0d53bcc0f2e44085d0e64ef58fc9938e053674655043ee5e1bf328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e3e7fd79737698b216342e9907bad5c7d15663c49fd00c8c4a7a7f8247c7f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d5449a221d1ace4e0fff4dd2667c6252607d2485354cd5c6e51fbfe36edeaa4"
    sha256 cellar: :any_skip_relocation, ventura:       "55bac91ad338c873452f9b72c1a931f576cdb7868a71d67a959dc43e45150cac"
    sha256                               arm64_linux:   "0637020b7f156bd493ce38b8f948ef5f200511d7aeba5496f8f7ec598d29d756"
    sha256                               x86_64_linux:  "ed1618d4b6571bddde83d2d6a00f5f730a0448355e75e1ecc9d44cf00759b509"
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_equal "55", pipe_output("#{bin}/datamash sum 1", shell_output("seq 10")).chomp
  end
end
