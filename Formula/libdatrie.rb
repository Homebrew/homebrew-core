class Libdatrie < Formula
  desc "Double-Array Trie Library"
  homepage "https://linux.thai.net/projects/datrie"
  url "https://github.com/tlwg/libdatrie/releases/download/v0.2.12/libdatrie-0.2.12.tar.xz"
  sha256 "452dcc4d3a96c01f80f7c291b42be11863cd1554ff78b93e110becce6e00b149"

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make", "install-am"
    system "make", "install-exec"
  end

  test do
    system "#{bin}/trietool"
  end
end
