class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/6.3.5.tar.gz"
  sha256 "17c9724bc8368a0878706d27a231aa699a8bf78ad804ca97413081bce69eb74c"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbee732a7304ed828f71ebe2ee5847637e54e2291bf498a899516090800066af"
    sha256 cellar: :any,                 arm64_sonoma:  "a0b4c4fd4c407a664e5ef6b9e4bd8debd5f6239aa5ceac40754bb7dacbbcffe2"
    sha256 cellar: :any,                 arm64_ventura: "a5c6154b7c474f89e552279acb816eb2f16fe580cf2b551476c48bed97d52a27"
    sha256 cellar: :any,                 sonoma:        "2814039645270a0de28354efc71e9e640e79113c4893edac270a3596e82cb74a"
    sha256 cellar: :any,                 ventura:       "53ca3c7313e167c4f82b00e9fc0f35bae6ebb80b15e3762f59668e4a34c44aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fbec0db0c78b0ce779195131d1e70118b6642dc6a66469f3bea2be7e0fdb35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa435ef982fe30b6e3ea26c1d736882a4799c0ee035bccb5cf20bdca00740dd"
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
