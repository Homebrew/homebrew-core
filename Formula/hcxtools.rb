class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.7.tar.gz"
  sha256 "c9d69b5ddcf61c3deff687fad6c17197970cc75c5dbc7706b31c138bf0c784e1"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e295981e6f8a11ffd1086bef7e3e73f9bc49fe1229af68b7ad24ea7b21891dcb"
    sha256 cellar: :any,                 arm64_big_sur:  "0561468149c5674c98702a611a5bb3700eb7bfb247b1309092cf2d4feda47a32"
    sha256 cellar: :any,                 monterey:       "f9b845ce6110401475ec132b16d6688c90533633de6c91481c4068917f3da906"
    sha256 cellar: :any,                 big_sur:        "a09ec24c7f5a2465d92199e786f1739686b71ed9639ab2515b974f3b20b2dd13"
    sha256 cellar: :any,                 catalina:       "222e136accd07aec2c73399df5a7bb555a708576686a61ab517bb974536a67dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe51da5eee5f3b62420ae8e2210b1ee40fedc46125faf15ef2da93eb04289306"
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
