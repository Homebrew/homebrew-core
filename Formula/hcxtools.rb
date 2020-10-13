class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.1.3.tar.gz"
  sha256 "15f02189a235b28d6853f231b5cef871a6d487414c3e631971226e8fed88dbcb"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    cellar :any
    sha256 "84df63e72e4a3af6321db5fddc230dadb5af2cf5140c1636a3cf870163b9f1d9" => :catalina
    sha256 "c3fece3c09f757513484007d5e366366724a3570d3a614309bb40a855f936ade" => :mojave
    sha256 "04f86422166a904d573bf86f08e561615f23b86f65b1b56db4f032fbe4021d49" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create file with 22000 hash line
    testhash = testpath/"test.22000"
    (testpath/"test.22000").write <<~EOS
      WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***
    EOS

    # Convert hash to .cap file
    testcap = testpath/"test.cap"
    system "#{bin}/hcxhash2cap", "--pmkid-eapol=#{testhash}", "-c", testpath/"test.cap"

    # Convert .cap file back to hash file
    newhash = testpath/"new.22000"
    system "#{bin}/hcxpcapngtool", "-o", newhash, testcap

    # Diff old and new hash file to check if they are identical
    system "diff", newhash, testhash
  end
end
