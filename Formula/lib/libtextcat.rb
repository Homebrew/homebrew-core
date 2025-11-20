class Libtextcat < Formula
  desc "N-gram-based text categorization library"
  homepage "https://software.wise-guys.nl/libtextcat/"
  url "https://software.wise-guys.nl/download/libtextcat-2.2.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/libtextcat/libtextcat-2.2.tar.gz/128cfc86ed5953e57fe0f5ae98b62c2e/libtextcat-2.2.tar.gz"
  sha256 "5677badffc48a8d332e345ea4fe225e3577f53fc95deeec8306000b256829655"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "b470b7355ee704a07a4768b12909b0c80501f241c57f257d4639147b0fda41eb"
    sha256 cellar: :any,                 arm64_sonoma:   "cc83f030e51cc9de7708c72e452fc0064c21cfbeb3b83e15970901c26f1e1cb0"
    sha256 cellar: :any,                 arm64_ventura:  "e5d60db841a6a8bd707de17b8e6e67f7113a9c8b54a1a614342f77797cbb041b"
    sha256 cellar: :any,                 arm64_monterey: "af621f1b2cfa2e6463bad63f3b7dbb77c928881dee5e41425489687c4849ceb0"
    sha256 cellar: :any,                 arm64_big_sur:  "a7d4587c077074798e16772f893cea69a90a99ff89b6071690a9980083b55e93"
    sha256 cellar: :any,                 sonoma:         "6589bf1866b9cf1e31aac4c96f93bd0167e11fa087f3bfb0dda9fdf6a7e373af"
    sha256 cellar: :any,                 ventura:        "fe31ac7c58baef452610658a4782c36300b4751b3cd360ed4b084efa952e6e0a"
    sha256 cellar: :any,                 monterey:       "6fc8d211fac04b40a803243f2d00e55c830a2f8cc12c9a2006f91efc0fdf7b62"
    sha256 cellar: :any,                 big_sur:        "894a917a9328865a92e965cb1bb4e5d74d8073299c501aba30e443a5451c5718"
    sha256 cellar: :any,                 catalina:       "9e178bd2a1479fb8d7be57c03b0bad722fbb94221d50b4b807bd6c89126492f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2104f4e2ec57f7f63de0e6f68d7b2dae82c6912146c17908f4fc1625a17bc7c5"
  end

  disable! date: "2025-01-01", because: :repo_removed

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    (include/"libtextcat/").install Dir["src/*.h"]
    share.install "langclass/LM", "langclass/ShortTexts", "langclass/conf.txt"
  end

  test do
    output = pipe_output(bin/"createfp", "abcdefghijklmnopqrstuvwxyz").lines
    expected = %w[
      _ rstuv opqr mno nopqr g y b c d e f u h i j k l m n o p q r s t xyz v w x a z lmnop efg jklmn hijkl defg fghij
      defgh hijk vwx bcdef lmno nop pqrs fgh tuvw xyz_ wxy opq ghi cdef _ab ghij nopq klmn pqr _a _abcd ab _abc bc
      pqrst cd hij de ef fg gh hi ij jk stuv kl lm mn wxyz_ no op pq qr uvwxy yz_ rs wxyz st tu uv stuvw vw wx xy yz
      z_ qrstu qrs opqrs mnopq ijk klmno bcde ijklm abc ghijk fghi efghi cdefg jklm abcde rst uvw jkl rstu bcd vwxy
      stu klm abcd cde efgh ijkl tuv mnop lmn qrst def uvwx vwxyz tuvwx
    ].map! { |line| "#{line}\n" }

    assert_equal expected, output
  end
end
