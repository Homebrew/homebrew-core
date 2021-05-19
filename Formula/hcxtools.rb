class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.0.tar.gz"
  sha256 "34435b08385ee23dbc1054e92e5b1a1637b352aa73fed301ef94b4b40a6165a1"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7562b2f0cef1710c74d5e0fadfa3c1af96ae9efb377047ddfdb12458d1e6fbdd"
    sha256 cellar: :any, big_sur:       "0c554af41156ff6960244494343c41a5847cd25eaeb503029220b4bb5e29fcc6"
    sha256 cellar: :any, catalina:      "31d5436dd03434c52eb41d9624ef83f16fbdb17067d801d9f04c7f86928d258b"
    sha256 cellar: :any, mojave:        "30d1a53db076b0bd9056e5daf2eebde64f97c977fa31de06461dfcaa04e4407b"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
