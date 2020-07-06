class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.0.3.tar.gz"
  sha256 "9a88a8ad609d4259e8892322711e812a5a3731ab1f16d347ae1fd2208d692a3e"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    cellar :any
    sha256 "ac97f5bfa367504cea6dae147971e34cc43fce130614804f8a796e7ef8eb1c7c" => :catalina
    sha256 "190a886d5aa509ec93acbdca3f870d2d44660a3cb595754c6324848cbaf3910c" => :mojave
    sha256 "c769742aa2e3952651d5c49fdb9cf8ecdfd7bf0575ec4cd8f2c3c6a584d576e7" => :high_sierra
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
