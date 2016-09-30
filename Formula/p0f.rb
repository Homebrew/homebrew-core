class P0f < Formula
  desc "Versatile passive OS fingerprinting, masquerade detection tool"
  homepage "http://lcamtuf.coredump.cx/p0f3/"
  url "http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.09b.tgz"
  sha256 "543b68638e739be5c3e818c3958c3b124ac0ccb8be62ba274b4241dbdec00e7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa7fc641ee01c5a805c43641ca0b7679c49fa83efd9ce5850b4b010a532dcddd" => :sierra
    sha256 "50c2e5d187d3757b325f4df21e5286412a4d5a548d697b4594cc771787223f8f" => :el_capitan
    sha256 "a67b2bdd45cd05e20990af97876ad793fea64b24c1ecb5fa51d7a717adbd0715" => :yosemite
    sha256 "646c5afbe2b880d8e882533f19629d0bae3f3a58efc1fde3850345dccf145f39" => :mavericks
  end

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc/"p0f").install "p0f.fp"
  end

  test do
    system "#{sbin}/p0f", "-r", test_fixtures("test.pcap")
  end
end
