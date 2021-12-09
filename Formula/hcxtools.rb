class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.5.tar.gz"
  sha256 "7ce5f8263cf9354f01008ba710c6e3cc2dcc861c550bd7a943ca33d29738bec3"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "644d2bf7094986be6b1cafc2410b40938f843880d051a796316e3bac0e37d75e"
    sha256 cellar: :any,                 arm64_big_sur:  "55b88dbc39f39c4ec5f07c3afc708a5dc04b259d7354f5f18cc232df7beb79df"
    sha256 cellar: :any,                 monterey:       "2e0b78e597ffc2590319dbcb5cc986bfb6449d75705d7da474cc02fb9e16446a"
    sha256 cellar: :any,                 big_sur:        "6d9f1847e331af5bcbd975ed58053dcc12bc00a185c39e8e6c0e54e45f0641b0"
    sha256 cellar: :any,                 catalina:       "dd54bad400bc297dcdef20dc923d0b774b7e00660b15d233b02c2f6d40ccb7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73dd363d7194dbe9d6a7e825209506b40b6edcf44e9604fe82731ece609ca068"
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
