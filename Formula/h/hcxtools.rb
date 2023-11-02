class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/6.3.2.tar.gz"
  sha256 "555e46a59df6a77c5aa73b99ffa8c1e84fa79e24ffaf5180de1d3a7f4ab7a470"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e579104b0f72973624df8560b968c59a8f8d2d039c891d920cfadc736fe60234"
    sha256 cellar: :any,                 arm64_ventura:  "6a9f12f80529e69a9bc098ca50a2d8e1aace3358dabdc6b25d5c4ab5da31afbf"
    sha256 cellar: :any,                 arm64_monterey: "d020750ff76b0f5f480aa1265d71e9f438b6098acd7232050ec7c73d28cba0f7"
    sha256 cellar: :any,                 sonoma:         "4581e01bae79aec9d243c3b640324fb067d7762f989d0eae0cd2f75e6448dd63"
    sha256 cellar: :any,                 ventura:        "a205c592f414ba685c499963924c60ed175b18ce237bb7949823f6ca3b25a595"
    sha256 cellar: :any,                 monterey:       "c69760226d8750516f2ba5b08c7a0771d37e686f05503120747c173fbcc85e35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17118b8277136578a40b7ddfc5bebdb5c6aeffd8565d92fc14c1f1d3585ecad"
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
