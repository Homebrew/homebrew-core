class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.4.tar.gz"
  sha256 "74299313dd15ed38f07b42201903ab85ebbc3ad220a01fff1bd5c967cfea817d"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b473d82b8435a07a793c0dab13138c3eb1cf03a7a5c4141fd580cc482582053c"
    sha256 cellar: :any,                 arm64_big_sur:  "71ab36699020855a425e5dab7dd64e6ed2de1dbbbedc3a84ca48c99ec60ab29d"
    sha256 cellar: :any,                 monterey:       "4f6f64cb36999b4eb9195dcaa0d285113f61687955e1ca9094e2aff5ce48d35b"
    sha256 cellar: :any,                 big_sur:        "e823f093cc594fcd8cec3c9fe7c5743d37323bfefc1f0c423ae7cab401936830"
    sha256 cellar: :any,                 catalina:       "97f4b6d9401be82a0d1c48ed80be2070147ff374be07a3123b763cc0f7210696"
    sha256 cellar: :any,                 mojave:         "9a93ac0c1f2b3172d3eb2b5f822c9c043a1d269fa881f35172f195f10628ff60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad17f6c779701195a56f451f8e862f3b7b6e13739cc4de746b76fd3da4996456"
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
