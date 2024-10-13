class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.net/"
  url "https://github.com/dharple/detox/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "46e646855cfeae5aa51d00c834f7eeeb5967188aaa17f8882a14f98343d82924"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia:  "481ed92a26b1e26953107580c9a6baa6e4c3c3fd6d773395125de4038a83e46e"
    sha256 arm64_sonoma:   "8faa1e95922d876ff01d233893f0cb83d07bcf2e916c231d15e94765d16efa21"
    sha256 arm64_ventura:  "79122f4f58434d19c69c182bc1709630b052dd7141e6810691b1f1e91175083f"
    sha256 arm64_monterey: "b105a28c660493298adf8cac087529dbafe41196b4f97b5e7d28a8543236b208"
    sha256 sonoma:         "cb3ba28c5bd713d4b8cbc3bd908270ff645481fa62b0d7d8c83e55c4e9ee984e"
    sha256 ventura:        "4e6159694a04362b11cec132dcacb70b1d84567c688614f7f887e8b7a1f43293"
    sha256 monterey:       "e39e5f5112ebedf0e3b44aab8d8af72c966698e9f4230797df96fffe24c82686"
    sha256 x86_64_linux:   "cb4ab816445009b488e415ec13b576903e89a89e367bcf31313896b589163448"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
