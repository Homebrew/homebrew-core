class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.9.tar.gz"
  sha256 "029f62003b90bed83fef34e62c1020e4178566e41c0c3f4525ace526fd02bfd0"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd520809604df090a7c797e3bd71563aee5c0e28bb16b1996df13e0c8800c79b"
    sha256 cellar: :any,                 arm64_monterey: "c7323b1a2a5bf0c7f716e4c82dd19cae28047387e7c3940794987b714992c91d"
    sha256 cellar: :any,                 arm64_big_sur:  "9953aa1c8fb8f595b9fc93f5c0a1a4cf0444e566e0a03eb4a6474c2d4a15f283"
    sha256 cellar: :any,                 ventura:        "0b9e4c8d20b70c24ead9ace5ee14d615d9956a199a5c3fc0f2728f8490fdf30a"
    sha256 cellar: :any,                 monterey:       "5c4009d927e4f73728dbbec849eefe083848b9bfb537525e92b53f8caf8c8781"
    sha256 cellar: :any,                 big_sur:        "05c7aecb385d87e318310cee951bab88430d97499e508b362193c56463aefa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93a81fdbc7388ce7e1f168e6cb5ba2eb9f512f7857da23ec65d11458e8160ba"
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

    # Diff old and new hash file to check if they are identical
    system "diff", newhash, testhash
  end
end
