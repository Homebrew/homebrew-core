class Msktutil < Formula
  desc "Active Directory keytab management"
  homepage "https://sourceforge.net/projects/msktutil/"
  url "https://downloads.sourceforge.net/project/msktutil/msktutil-0.5.1.tar.bz2"
  sha256 "ec02f7f19aa5600c5d20f327beaef88ee70211841dc01fa42eb258ae840ae6f0"

  devel do
    url "https://downloads.sourceforge.net/project/msktutil/msktutil-1.0rc2.tar.bz2"
    sha256 "07884a98fd86dfb704dc6302a56fcf2ccb3d8a34fb95dcb00e5e86428d91103b"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ed2c180be51a19de7b014a28d8f34310f87f283f03ba72cc55f9ac0a5c249e3b" => :el_capitan
    sha256 "678a75fcba0b6c1ba926845b07bde8bff4ae96b3f069d62a3ceb853da474fe2a" => :yosemite
    sha256 "fba7badc2d24de3a5e8e84d274a37d9007c938d877ab34fa2b91110b91eacb10" => :mavericks
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
