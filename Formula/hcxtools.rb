class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  stable do # remove block when patch is no longer needed
    url "https://github.com/ZerBea/hcxtools/archive/6.1.6.tar.gz"
    sha256 "27b1b1ad722b9d82f8e92c6bec92d081159e5b8225bd2a477bf8d304ff4aeb03"

    # Fix build failure on macOS. Remove at next release.
    # https://github.com/ZerBea/hcxtools/issues/186
    patch do
      url "https://github.com/ZerBea/hcxtools/commit/f592df4bd1bfcc4ade8e6396587fd27dc8f154f5.patch?full_index=1"
      sha256 "9393c16de231d6a77d395c4200e094bff38a937ae300dc7f56a69cc4a26644a1"
    end
  end

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
