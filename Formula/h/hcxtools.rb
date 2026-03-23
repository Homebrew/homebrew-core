class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/refs/tags/7.1.2.tar.gz"
  sha256 "c726b93df32efd3298874b324f820d93cb08a4dae03d9144b0d5062c003fd77f"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b786532da808f3d2df2a0196664c412cbcb7b9e8075ff4986be97516c7dda34c"
    sha256 cellar: :any,                 arm64_sequoia: "b6ed19ef3e202ff7fccd37d1cb507a15ae9d27a0642b9adaed3f681d0898c167"
    sha256 cellar: :any,                 arm64_sonoma:  "1651738e247aacea8e5370cd6864c7c74ea469326838eceb9a26fe0545c20bf3"
    sha256 cellar: :any,                 sonoma:        "f780ee105f6fad885e76c94ca9dc0d0f262c45bcdbee5ab91f9db46c6006d6b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5dd620ba49c62840721470976e8c9fc315ccf53073a970e2fb773fab2b514a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8168c9e6a68a1707ec3c18c7f4c141664f1f9609f3432b761e2e076c0a3f71a7"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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
