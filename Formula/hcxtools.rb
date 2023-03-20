class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.9.tar.gz"
  sha256 "029f62003b90bed83fef34e62c1020e4178566e41c0c3f4525ace526fd02bfd0"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8dd4a105c72a9cc05074ab60c5eb3bccba621f93f888dca4ba32fc1c4fb1ebf8"
    sha256 cellar: :any,                 arm64_monterey: "838d37369775fd1827bb88ad3d5e3a7d962c33c3f4d40a48bd3e04130caa8f50"
    sha256 cellar: :any,                 arm64_big_sur:  "60467803fde2194f29a041754cb40b1ea89fcdb0e4dfb3a4e1ad5035b4143f49"
    sha256 cellar: :any,                 ventura:        "f7353a5916d1a7b6dca9932b6511c63b3a68559e6269714e06bf5cbca76b1fd6"
    sha256 cellar: :any,                 monterey:       "40ffcac88c0bb8a8bc6316f7f804c3294099c524f0a4ad310076fc42760dd44c"
    sha256 cellar: :any,                 big_sur:        "cfe76be515cf33d773d08978100a4922755f92f731858ae1f071441b0afb4dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4715e2d599fce7cde09b9929fa32d4bc486c8daac8fde8c3195ef157ce66b1f"
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
