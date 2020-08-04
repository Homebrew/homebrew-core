class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.1.0.tar.gz"
  sha256 "b96b87e6540fc04c6632f9f1dc4906dd2b647f5b9aae20767a7cfb7332528bb9"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    cellar :any
    sha256 "d9d7d3837dea826ead3aadcacde27c7bb844a6db4602e207078ed5917806ed15" => :catalina
    sha256 "baddf46945764397518692d835d6dc763f4ad2921ad86b133d3ff2cd620948c0" => :mojave
    sha256 "0d2a9b1419456d7aaf880bcd997c8a93c51c1c594c83e7437b20c3a79c3bd698" => :high_sierra
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
