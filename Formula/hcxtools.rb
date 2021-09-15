class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.0.tar.gz"
  sha256 "34435b08385ee23dbc1054e92e5b1a1637b352aa73fed301ef94b4b40a6165a1"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "86ea3336cc5093ebec9fae73aa3ca4479b129ad45be48f95e5905897e4f4a7ed"
    sha256 cellar: :any,                 big_sur:       "e62e01f85aeed6210869c83cf55a8a80465c71def942d7a9327e8b321cfb1347"
    sha256 cellar: :any,                 catalina:      "558d23ae99efd0692340cd1adaac5ea7069c6add058a5dd0ca1f5cabb564ef35"
    sha256 cellar: :any,                 mojave:        "8508059eaf7d76ba6a038b80a6eaf5a5aa0bbbdeff359359b13970593c3a1de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a756629cc5b4e8293db607d3323c09a3813fe16ab4a7c97db83b6b5293e4be6"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

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
