class Msktutil < Formula
  desc "Active Directory keytab management"
  homepage "https://sourceforge.net/projects/msktutil/"
  url "https://downloads.sourceforge.net/project/msktutil/msktutil-1.0.tar.bz2"
  sha256 "6e59d4bf41b8c75d573037c19ed29567a55f67ae5fe8c81e037b4f8c7327b642"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fca13319f0fd70ef806359e27093471ce1b96fdfcc7323a09376be0559797a28" => :sierra
    sha256 "c4705552a9bd29dac8f579b3d78c373a69a2609f0b72371308c8eb70a78d7ed9" => :el_capitan
    sha256 "0508df72823bc5ac407a6e817e49e973bd3c1230c02c0957bbb5da9b3e65117f" => :yosemite
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
