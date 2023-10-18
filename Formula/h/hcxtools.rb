class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.3.1.tar.gz"
  sha256 "3570f88448a5c65273fdaf4e9d764f2b9d87c300dafa645a3e54394130db71a1"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ee5f01a672fe46b02e774eec136bf2a5c161d3336e4f38cb2b07f38b0438acf"
    sha256 cellar: :any,                 arm64_ventura:  "bc2799060b91b448c1b3240593920e0aeb83e5e466d260ad9661fdd8bbe5a31e"
    sha256 cellar: :any,                 arm64_monterey: "6a1f47f177a3c7c722be5cb42401bfac6b5d3b7c11641c2b37f2a1a6d8e9e559"
    sha256 cellar: :any,                 arm64_big_sur:  "da64ee096b4f490237955607bacb1a72cc3df188400759a2c817c28ea462cbbe"
    sha256 cellar: :any,                 sonoma:         "0228df978c220b451bd89072e18ac71895fec4776b3f3bdf031af10cfdfdc631"
    sha256 cellar: :any,                 ventura:        "6ea7825bd2d2425ae36eb8bd5e884391f84a63f172fe30c9610707673f75b964"
    sha256 cellar: :any,                 monterey:       "28af85ebf8fa2b147d203b42a336ae8c64c1009fd8e70c3194c23a8b921184ef"
    sha256 cellar: :any,                 big_sur:        "4be6dc30604bba139024e5ac1cba60c258316e2ae2552ab4f3df57d99a7447f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4cc839a3d3958c6fbdacbc075e75cfbe3416766ec991605fef7ca2c32c2832b"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

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

    expected = "WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***01"
    assert_equal expected, newhash.read.chomp
  end
end
