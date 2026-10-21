class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/7.1.2.tar.gz"
  sha256 "c726b93df32efd3298874b324f820d93cb08a4dae03d9144b0d5062c003fd77f"
  license "MIT"
  revision 1
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b5f01178ab5387a809deeedc4197aa5f7e97e01dd7c312c1ee2e7f2972965c01"
    sha256 cellar: :any, arm64_tahoe:       "9e01f404748137c27638c3464800c31f4dea874205be7af2c70eeb439db55946"
    sha256 cellar: :any, arm64_sequoia:     "948b82734d6251902c54d3397525ea88667ab287c8e33c2a9657a668594fb713"
    sha256 cellar: :any, arm64_linux:       "cab3a33d7881a68af1e80e1ddd8862616ac2ce99d93f03e139f0030367f4ba4a"
    sha256 cellar: :any, x86_64_linux:      "4209db6ddbfa401e969326c7a6e364d00fab66d938d7d0be8d909c9bf0dfc949"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
