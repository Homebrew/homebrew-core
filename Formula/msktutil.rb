class Msktutil < Formula
  desc "Active Directory keytab management"
  homepage "https://sourceforge.net/projects/msktutil/"
  url "https://downloads.sourceforge.net/project/msktutil/msktutil-1.1.tar.bz2"
  sha256 "56bf4af8f74d8be6a8d94b90a527acf1508cd58212886fcfe54daa9799dcaf6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa3eeff895b2de1989222a0da68b9bfd1f82a84e1aa09e060f96a018c51c9f1d" => :catalina
    sha256 "c81aaec915e611272f5c74d5a4ee7b14d9e7342d7bc2639f45dd90b0f3fc639b" => :mojave
    sha256 "8f3695f42884ee17bc1b701ee968c60e5ff115c17b9514986c7dd499b8e229c2" => :high_sierra
    sha256 "05fc6f711b6109052fa1a795bf88063490e5c2ed73bcf2f2168610c77e996d88" => :sierra
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
