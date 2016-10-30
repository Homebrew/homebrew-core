class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "http://bashdb.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.4-0.92/bashdb-4.4-0.92.tar.bz2"
  version "4.4-0.92"
  sha256 "6a8c2655e04339b954731a0cb0d9910e2878e45b2fc08fe469b93e4f2dbaaf92"

  bottle do
    cellar :any_skip_relocation
    sha256 "acaeaec58a610b8ee53f3ef1ebbee800991b1790a50bf38f6496e4c3e07a8a40" => :el_capitan
    sha256 "407d84f8f4e34a1f9accaf6a5cb74c50028b97009842c592b969020e5a04630e" => :yosemite
    sha256 "f715486224a5d5625b9cc5645235e7f977fce749254dbde3254028b2700d8860" => :mavericks
  end

  depends_on "bash"
  depends_on :macos => :mountain_lion

  def install
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bashdb --version 2>&1")
  end
end
