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
    sha256 cellar: :any, arm64_big_sur: "7203d4127bf7bffe5ef0ce0ac53bf06ef4d3d46f5acad23eb084268a1fd68df1"
    sha256 cellar: :any, big_sur:       "99013be82236937ee4f100fc0e52b19d45a6e2c15952e116fcf1394873b8af9d"
    sha256 cellar: :any, catalina:      "d8f6de053a88b742ac743f88d8f22f49e4f01fe6ea3f3be2fa235b2db80cd38f"
    sha256 cellar: :any, mojave:        "57d98cd8c5744413822fd26bd3445c076a22c24a664451a2b64d413e8a2a5ca5"
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
