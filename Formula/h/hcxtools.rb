class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/6.3.4.tar.gz"
  sha256 "1d507688bc919b970734f853dd659d64d54e6e49b16a2c6e55d903dff2b2a957"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "baf8fe97daa9ab06a4493463399f97e2835c3847270994891eaf959bf64d2a04"
    sha256 cellar: :any,                 arm64_sonoma:   "6e2c39029b7060c87e8ec1bfb6e71eeac1da42971d775b44f022f69e7968ce12"
    sha256 cellar: :any,                 arm64_ventura:  "13df5da62f36c0065a3939bc8be5484c6578bfcab67049fbfd3a836ce747ba11"
    sha256 cellar: :any,                 arm64_monterey: "d1c9dd58578e4ae79e92496d23e482f05eb6067269d7202595162793bfb7344a"
    sha256 cellar: :any,                 sonoma:         "772803944814e5a07b2430bc92c7637a17fbff0f4e8714876da7845a2822f647"
    sha256 cellar: :any,                 ventura:        "86ff1f26722c263873311920e7da72ba34f1b5e0f1931be22baef828ae9ef55b"
    sha256 cellar: :any,                 monterey:       "205baf524f5e111a5d1b9842accd8b0729134db969830f000ebbfe3f94a940ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f43a8a590d5f33c06511c8baebcaa2f5a4463a03183bc6081632bbc50eb0fc2"
  end

  depends_on "pkg-config" => :build
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
