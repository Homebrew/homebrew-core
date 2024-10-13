class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip/"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.13.tar.gz"
  sha256 "20fc818aeebae87cdbf209d35141ad9d3cf312b35a5e6be61bfcfbf9eddd212a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "359aaa0923f31127cbe534ce8641d8f39296bf6aa1d09b6aedd735f9c7e3886d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38a03ba8613b6fe20ef75870676c52459bbb536635d060efddc11b56fb8bfe24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ae3a3e940815c0e947e8a15492927b8cf2dcc9b9605cbae983026b2e50751d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa80caf733d87c7f2178bde35b8773ea4cab0e8eb3d644be62f9a87b6a8e0a73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "612394a14dd27080b7798fe19176305eee42964322efbaf839a69d0dfd86fea4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff2ea3868d2d3841cc503217762ead7418a2ba798afec54acb075af2e20945e"
    sha256 cellar: :any_skip_relocation, ventura:        "3ceb7fbd84af53592664bb539e35aa67ca850c61638c9b6e76f631579fb92179"
    sha256 cellar: :any_skip_relocation, monterey:       "dc0fdc85159932f9f7e5fa0626246aaa8e15e5161e6ee45c953fcd3b424cbf9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfc4297fa730a00992dccd456d9f3629c820bb23dfd02dff908b21573d5b48e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118bb27498a8169304d2635231cdefc07bb405b31b464df54c64129977f7581a"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"gzip", "foo"
    system bin/"gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
