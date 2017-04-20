class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "https://bashdb.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.4-0.92/bashdb-4.4-0.92.tar.bz2"
  version "4.4-0.92"
  sha256 "6a8c2655e04339b954731a0cb0d9910e2878e45b2fc08fe469b93e4f2dbaaf92"

  bottle do
    cellar :any_skip_relocation
    sha256 "36ab7e6dbffac6255d2a395581da8b9db1e0490abf2bc7c939c44429211313a4" => :sierra
    sha256 "36ab7e6dbffac6255d2a395581da8b9db1e0490abf2bc7c939c44429211313a4" => :el_capitan
    sha256 "36ab7e6dbffac6255d2a395581da8b9db1e0490abf2bc7c939c44429211313a4" => :yosemite
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
