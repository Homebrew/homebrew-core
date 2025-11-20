class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/7.0.1.tar.gz"
  sha256 "7697c429327cb9cef64bcd47e33988d691327ae62ac53ec74aa25097d8ef246d"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e186bc96dc8ed8655a606b23063c900526f53b77ac3f7816dc33f3c367571eeb"
    sha256 cellar: :any,                 arm64_sequoia: "8a44c55d3ac2d1b789f8672b4d2b98b2b689dafe93d816f9e3f662e519177f5e"
    sha256 cellar: :any,                 arm64_sonoma:  "0880e5b371e3ed209906d9129c3813582cda3e9846817b660a79f641ad54d689"
    sha256 cellar: :any,                 arm64_ventura: "47ce8391e0cfdda4d7657b515887565c1140e75e45d1271dc3155c54884ec45c"
    sha256 cellar: :any,                 sonoma:        "d5a42d28eb99193bc9b28c9a50a55ff41fe0a5d0dd79cf0892b7d926bf4c064e"
    sha256 cellar: :any,                 ventura:       "4bcf4a1dadd14ad9f50b3fb7a60d4dacbf71d82e31dc12d24970027bfbfdf025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f6ddacc261c7176ff1358bf0653a2b61bc26acfd7fde2dd116c8255435e3b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d05defbcae9e5c3c6e3aa8be76e8b3ec19e38049a1fdc1495e80826d3755b70"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
    system bin/"hcxhash2cap", "--pmkid-eapol=#{testhash}", "-c", testpath/"test.cap"

    # Convert .cap file back to hash file
    newhash = testpath/"new.22000"
    system bin/"hcxpcapngtool", "-o", newhash, testcap

    expected = "WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***01"
    assert_equal expected, newhash.read.chomp
  end
end
