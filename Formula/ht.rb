class Ht < Formula
  desc "Viewer/editor/analyzer for executables"
  homepage "https://hte.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2"
  sha256 "31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0669645033eb4eeecad54df5e43bc733ce4cc527fa52f2277c002296b2207753" => :mojave
    sha256 "8c604066c63fa1eba3bb547626bbc280ea4446bb2961cb54e8b4fc7b829af5c4" => :high_sierra
    sha256 "197a62339202dd45529bbf42b67addc35939dbae43cc9704ff15d75e5ad62d01" => :sierra
    sha256 "4556713b40bfd3846c7c03a02c174bff2a771fba4084721b6faed88437c3c1a2" => :el_capitan
  end

  depends_on "lzo"

  def install
    # Fix compilation with Xcode 9
    # https://github.com/sebastianbiallas/ht/pull/18
    inreplace "htapp.cc", "(abs(a - b) > 1)", "(abs((int)a - (int)b))"

    chmod 0755, "./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make", "install"
  end

  test do
    assert_match "ht #{version}", shell_output("#{bin}/ht -v")
  end
end
