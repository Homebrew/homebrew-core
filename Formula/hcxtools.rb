class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.3.0.tar.gz"
  sha256 "cb691b3d6b3f2ec7b63c79697b9a977338394b90c8f93ba596525d601134452f"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9e2bac4c1ad566642feeb4ce0999bab6c1cad68e2e93d2397986a99c161d35ca"
    sha256 cellar: :any,                 arm64_monterey: "f0b7b3a34ca48454b8d5727fab6e03d77790760dda835f281d366b8b143927af"
    sha256 cellar: :any,                 arm64_big_sur:  "9f7d203677b60b0fd7422fa0fcf1ecd403e5edc0a27c6d11389e25fa07229754"
    sha256 cellar: :any,                 ventura:        "2cafeaa6ed13b4d5f66421ad2e8e9f208e6fd5f11331f46b157b650f5d96cb82"
    sha256 cellar: :any,                 monterey:       "62c092e12a51eb4406dc32bcbe6a12bd21510db7101b985bc640576178cbc95e"
    sha256 cellar: :any,                 big_sur:        "d3455191f0d960ee5f546a0b23f1bbe75c219140904683fb4b525ef8d67b2593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9664e4342a17634abdbf9e79d9ed1c853af80230a47884f6d3f1907cb2afbc7a"
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
