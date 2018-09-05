class Msktutil < Formula
  desc "Active Directory keytab management"
  homepage "https://sourceforge.net/projects/msktutil/"
  url "https://downloads.sourceforge.net/project/msktutil/msktutil-1.0.tar.bz2"
  sha256 "6e59d4bf41b8c75d573037c19ed29567a55f67ae5fe8c81e037b4f8c7327b642"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f77290c5288ec446836d564636482abccb88b110a98cdd6499e97733d4fc39b" => :mojave
    sha256 "cba1afff1683efb3d6f6d500047c10691b0f46c904f404d8fbfdbed08200cc54" => :high_sierra
    sha256 "3bf390f92696706f4f6241230024c9bdb13c78c05c9f81faffc356cbcb4ed443" => :sierra
    sha256 "190a11fe9d63b99fe2982a79d83bd7ba59f4c7ef104ce860eb9ae48acb56335b" => :el_capitan
    sha256 "c88bffcb5bacc334333d1bf614005ce65acb4d40e8c73f249313762e017ee8bb" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/msktutil --version")
  end
end
