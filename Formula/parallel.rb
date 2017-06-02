class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20170522.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20170522.tar.bz2"
  sha256 "8a0d51632921b80102817151b62ea17eed6b28d088c40d94ed4ee40618a3bccc"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6152111a96cef8945a58d96e6b8fa91931d9d25bc33a4e01e93169fb3966fc08" => :sierra
    sha256 "51102dc5bbc06d65178b38a49cee9088ccf9b693c7bc52e998abce7d3384a68b" => :el_capitan
    sha256 "51102dc5bbc06d65178b38a49cee9088ccf9b693c7bc52e998abce7d3384a68b" => :yosemite
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
