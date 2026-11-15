class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/8.0.0.tar.gz"
  sha256 "4cc9dfe7ab2c7d5cc5f39f887741499b146ee14d0a50bda8113025a0041b3c1e"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "98183e96545a092ed009d64af62b20a816596237508f25db979d2da8af3bb86b"
    sha256 cellar: :any, arm64_tahoe:       "e4c48db281a4b647b10e3caf618616a387b4c930b760004c0add9300b8412627"
    sha256 cellar: :any, arm64_sequoia:     "a8089fea0f570e9a3e88c29d4b50f32dd47da0eb264b674e78a3b0a4b5eb6e9f"
    sha256 cellar: :any, arm64_linux:       "16f91834b3818bb58d7997798e3ee50878b43f0bb8a7fc94ef07f09fbc08a62a"
    sha256 cellar: :any, x86_64_linux:      "784ee30bcf3f39ebe59054c25a3719187391ecd3d734dfd8d64e7071038d32cc"
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
