class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "https://bashdb.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.4-0.94/bashdb-4.4-0.94.tar.bz2"
  version "4.4-0.94"
  sha256 "5931afc2f153aa595b4c59e53d303d845952ab6101227c34654a1b83686dc006"

  bottle do
    cellar :any_skip_relocation
    sha256 "c16468585dfc75cdc28379afdbd5a506e7a842be3cbbb91249063b614b6ab94f" => :sierra
    sha256 "c16468585dfc75cdc28379afdbd5a506e7a842be3cbbb91249063b614b6ab94f" => :el_capitan
    sha256 "c16468585dfc75cdc28379afdbd5a506e7a842be3cbbb91249063b614b6ab94f" => :yosemite
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
